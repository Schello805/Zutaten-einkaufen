import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ShoppingListViewModel()
    @State private var showingScanner = false
    @State private var showingShareSheet = false
    @State private var showingCameraHint = false
    @State private var editingItemId: UUID? = nil
    @State private var showingDeleteConfirmation = false
    @State private var showingClearConfirmation = false
    @State private var recipeName: String = ""
    @State private var hasShownCameraHint = UserDefaults.standard.bool(forKey: "HasShownCameraHint")
    @State private var showSettings = false
    @State private var showDeleteAlert = false
    @State private var showingAddItemSheet = false
    @State private var newItemName = ""
    @State private var newItemQuantity = ""
    @State private var selectedCategory = Category.other
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.items.isEmpty {
                    EmptyStateView(showingScanner: $showingScanner)
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            GroceryItemRow(
                                item: item,
                                editingItemId: $editingItemId,
                                viewModel: viewModel
                            )
                        }
                        .onDelete(perform: viewModel.removeItem)
                        .onMove(perform: viewModel.moveItem)
                    }
                }
                
                if viewModel.isAnalyzing {
                    LoadingView(message: "Analysiere Zutaten...")
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .onTapGesture {
                            viewModel.errorMessage = nil
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    }
                    .buttonStyle(.bordered)
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Einkaufsliste")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingAddItemSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                        
                        Button(action: {
                            if hasShownCameraHint {
                                showingScanner = true
                            } else {
                                showingCameraHint = true
                            }
                        }) {
                            Image(systemName: "doc.text.viewfinder")
                                .font(.system(size: 20))
                                .foregroundColor(.primary)
                        }
                        
                        if !viewModel.items.isEmpty {
                            Menu {
                                Button(role: .destructive, action: {
                                    showingClearConfirmation = true
                                }) {
                                    Label("Liste leeren", systemImage: "trash")
                                }
                                
                                Button(action: {
                                    showingShareSheet = true
                                }) {
                                    Label("Liste teilen", systemImage: "square.and.arrow.up")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(showDeleteAlert: $showingClearConfirmation)
            }
            .sheet(isPresented: $showingScanner) {
                VStack {
                    TextField("Rezeptname", text: $recipeName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    CameraView(viewModel: viewModel)
                        .onAppear {
                            viewModel.currentRecipe = recipeName
                        }
                        .onChange(of: recipeName) { oldValue, newValue in
                            viewModel.currentRecipe = newValue
                        }
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: [viewModel.shareList()])
            }
            .sheet(isPresented: $showingAddItemSheet) {
                NavigationView {
                    Form {
                        Section(header: Text("Artikel Details")) {
                            TextField("Name", text: $newItemName)
                            TextField("Menge (z.B. 500g)", text: $newItemQuantity)
                            Picker("Kategorie", selection: $selectedCategory) {
                                ForEach(Category.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                        }
                    }
                    .navigationTitle("Artikel hinzufügen")
                    .navigationBarItems(
                        leading: Button("Abbrechen") {
                            showingAddItemSheet = false
                        },
                        trailing: Button("Hinzufügen") {
                            addNewItem()
                        }
                        .disabled(newItemName.isEmpty)
                    )
                }
            }
            .alert("Tipp zum Scannen", isPresented: $showingCameraHint) {
                Button("Verstanden") {
                    hasShownCameraHint = true
                    UserDefaults.standard.set(true, forKey: "HasShownCameraHint")
                    showingScanner = true
                }
            } message: {
                Text("Halten Sie die Kamera ruhig über das Rezept.\n\nDie App erkennt automatisch den Text und fügt die Zutaten Ihrer Liste hinzu.")
            }
            .alert("Alle Einträge löschen?", isPresented: $showingDeleteConfirmation) {
                Button("Abbrechen", role: .cancel) {}
                Button("Löschen", role: .destructive) {
                    viewModel.removeAllItems()
                }
            } message: {
                Text("Diese Aktion kann nicht rückgängig gemacht werden.")
            }
            .alert("Alle Einträge löschen?", isPresented: $showingClearConfirmation) {
                Button("Abbrechen", role: .cancel) {}
                Button("Löschen", role: .destructive) {
                    viewModel.removeAllItems()
                }
            } message: {
                Text("Diese Aktion kann nicht rückgängig gemacht werden.")
            }
        }
    }
    
    private func addNewItem() {
        let quantity = Quantity.parse(from: newItemQuantity) ?? Quantity(amount: 0, unit: "")
        let item = GroceryItem(
            name: newItemName,
            quantity: quantity,
            category: selectedCategory,
            isChecked: false
        )
        viewModel.addItem(item)
        
        // Reset form
        newItemName = ""
        newItemQuantity = ""
        selectedCategory = .other
        showingAddItemSheet = false
    }
}

struct GroceryItemRow: View {
    let item: GroceryItem
    @Binding var editingItemId: UUID?
    @ObservedObject var viewModel: ShoppingListViewModel
    
    @State private var editedText: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isChecked ? .green : .gray)
                .onTapGesture {
                    viewModel.toggleItemChecked(item)
                }
            
            if editingItemId == item.id {
                TextField("Zutat", text: $editedText, onCommit: {
                    editingItemId = nil
                    if !editedText.isEmpty {
                        if let index = viewModel.items.firstIndex(where: { $0.id == item.id }) {
                            viewModel.updateItem(at: index, with: editedText)
                        }
                    }
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onAppear {
                    editedText = item.name
                }
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.category.icon)
                            .foregroundColor(item.category.color)
                        Text(item.name)
                            .strikethrough(item.isChecked)
                        Spacer()
                        if let total = item.totalQuantity {
                            Text(total.toString())
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    if !item.quantities.isEmpty {
                        Text(item.formatQuantities())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            editingItemId = item.id
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                viewModel.removeItem(at: IndexSet([viewModel.items.firstIndex(where: { $0.id == item.id })!]))
            } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

struct LoadingView: View {
    let message: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text(message)
                    .foregroundColor(.white)
                    .padding(.top)
            }
            .padding()
            .background(Color.gray.opacity(0.5))
            .cornerRadius(10)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ContentView()
}