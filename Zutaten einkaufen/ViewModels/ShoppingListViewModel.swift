import SwiftUI

@MainActor
class ShoppingListViewModel: ObservableObject {
    @Published var items: [GroceryItem] = []
    @Published var isAnalyzing: Bool = false
    @Published var errorMessage: String?
    @Published var currentRecipe: String = ""  // Name des aktuellen Rezepts
    
    private let textAnalysisService = TextAnalysisService()
    private let settingsManager = SettingsManager.shared
    
    init() {
        loadItems()
    }
    
    func addItem(_ newItem: GroceryItem) {
        // Prüfe ob die Zutat ausgeschlossen ist
        if settingsManager.isIngredientExcluded(newItem.name) {
            return
        }
        
        // Suche nach existierendem Item mit gleichem Namen
        if let index = items.firstIndex(where: { $0.name.lowercased() == newItem.name.lowercased() }) {
            // Füge die neue Menge zum existierenden Item hinzu
            if let quantity = newItem.quantities.first {
                items[index].addQuantity(quantity.quantity, recipe: quantity.recipe)
            }
        } else {
            // Füge neues Item hinzu
            items.append(newItem)
        }
        saveItems()
    }
    
    func removeItem(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        saveItems()
    }
    
    func moveItem(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
        saveItems()
    }
    
    func toggleItemChecked(_ item: GroceryItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isChecked.toggle()
            saveItems()
        }
    }
    
    func updateItem(at index: Int, with newText: String) {
        guard index >= 0 && index < items.count else { return }
        items[index].name = newText
        saveItems()
    }
    
    func processScannedImage(_ image: UIImage) {
        errorMessage = nil
        
        Task {
            isAnalyzing = true
            defer { isAnalyzing = false }
            
            do {
                let results = try await textAnalysisService.analyzeImage(image)
                
                var addedItems = false
                for result in results {
                    if result.isIngredient {
                        let quantity = result.quantity != nil ? Quantity(amount: result.quantity!, unit: result.unit ?? "") : nil
                        let category = Category.detect(from: result.ingredient)
                        let item = GroceryItem(
                            name: result.ingredient,
                            quantity: quantity,
                            recipe: currentRecipe,  // Verwende den Namen des aktuellen Rezepts
                            category: category
                        )
                        addItem(item)
                        addedItems = true
                    }
                }
                
                if !addedItems {
                    errorMessage = "Keine Zutaten im Bild gefunden. Versuchen Sie es mit einem anderen Ausschnitt oder einem besser beleuchteten Foto."
                }
            } catch {
                errorMessage = "Fehler bei der Bildanalyse: \(error.localizedDescription)"
                print("Fehler bei der Bildanalyse: \(error)")
            }
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    func shareList() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "de_DE")
        
        var shareText = "📝 Einkaufsliste für \(dateFormatter.string(from: Date()))\n\n"
        
        if !items.isEmpty {
            // Gruppiere Items nach Kategorie
            let groupedItems = Dictionary(grouping: items, by: { $0.category })
            let sortedCategories = Category.allCases.filter { groupedItems.keys.contains($0) }
            
            for category in sortedCategories {
                if let categoryItems = groupedItems[category] {
                    shareText += "\n\(category.rawValue):\n"
                    for item in categoryItems.sorted(by: { $0.name < $1.name }) {
                        shareText += "• \(item.name)"
                        if !item.quantities.isEmpty {
                            shareText += "\n  \(item.formatQuantities().replacingOccurrences(of: "\n", with: "\n  "))"
                        }
                        if item.isChecked {
                            shareText += " ✓"
                        }
                        shareText += "\n"
                    }
                }
            }
        }
        
        shareText += "\n──────────────────\n"
        shareText += "Erstellt mit der Einkaufslisten-App"
        
        return shareText
    }
    
    func removeAllItems() {
        items.removeAll()
        saveItems()
    }
    
    // MARK: - Private Methods
    
    private func loadItems() {
        if let data = UserDefaults.standard.data(forKey: "ShoppingList"),
           let decodedItems = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            items = decodedItems
        }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "ShoppingList")
        }
    }
}
