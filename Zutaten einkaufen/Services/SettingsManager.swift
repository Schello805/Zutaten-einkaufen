import Foundation

class SettingsManager: ObservableObject {
    @Published var excludedIngredients: Set<String> = []
    @Published var suggestedIngredients: [String] = []
    
    private let excludedIngredientsKey = "ExcludedIngredients"
    private let suggestedIngredientsKey = "SuggestedIngredients"
    
    static let shared = SettingsManager()
    
    private let defaultSuggestions = [
        "Wasser",
        "Salz",
        "Pfeffer",
        "Öl",
        "Olivenöl",
        "Zucker",
        "Mehl",
        "Butter"
    ]
    
    init() {
        loadExcludedIngredients()
        loadSuggestedIngredients()
    }
    
    func addExcludedIngredient(_ ingredient: String) {
        let normalizedIngredient = ingredient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        excludedIngredients.insert(normalizedIngredient)
        saveExcludedIngredients()
    }
    
    func removeExcludedIngredient(_ ingredient: String) {
        let normalizedIngredient = ingredient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        excludedIngredients.remove(normalizedIngredient)
        saveExcludedIngredients()
    }
    
    func isIngredientExcluded(_ ingredient: String) -> Bool {
        let normalizedIngredient = ingredient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        return excludedIngredients.contains(normalizedIngredient)
    }
    
    func addSuggestedIngredient(_ ingredient: String) {
        let normalizedIngredient = ingredient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if !suggestedIngredients.contains(normalizedIngredient) {
            suggestedIngredients.append(normalizedIngredient)
            saveSuggestedIngredients()
        }
    }
    
    func removeSuggestedIngredient(_ ingredient: String) {
        let normalizedIngredient = ingredient.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        suggestedIngredients.removeAll { $0.lowercased() == normalizedIngredient }
        saveSuggestedIngredients()
    }
    
    private func loadExcludedIngredients() {
        if let data = UserDefaults.standard.array(forKey: excludedIngredientsKey) as? [String] {
            excludedIngredients = Set(data)
        }
    }
    
    private func saveExcludedIngredients() {
        UserDefaults.standard.set(Array(excludedIngredients), forKey: excludedIngredientsKey)
    }
    
    private func loadSuggestedIngredients() {
        if let data = UserDefaults.standard.array(forKey: suggestedIngredientsKey) as? [String] {
            suggestedIngredients = data
        } else {
            // Beim ersten Start die Standardvorschläge laden
            suggestedIngredients = defaultSuggestions
            saveSuggestedIngredients()
        }
    }
    
    private func saveSuggestedIngredients() {
        UserDefaults.standard.set(suggestedIngredients, forKey: suggestedIngredientsKey)
    }
}
