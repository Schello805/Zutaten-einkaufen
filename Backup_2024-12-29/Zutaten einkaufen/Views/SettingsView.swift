import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var settingsManager = SettingsManager.shared
    @State private var newIngredient: String = ""
    @State private var showingAddSuggestion = false
    @State private var newSuggestion: String = ""
    @Binding var showDeleteAlert: Bool
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Aktionen")) {
                    Button(action: {
                        showDeleteAlert = true
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            Text("Alles löschen")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                Section(header: Text("Neue Zutat ausschließen")) {
                    HStack {
                        TextField("Zutat eingeben", text: $newIngredient)
                        
                        Button(action: {
                            if !newIngredient.isEmpty {
                                settingsManager.addExcludedIngredient(newIngredient)
                                newIngredient = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .disabled(newIngredient.isEmpty)
                    }
                }
                
                Section(header: HStack {
                    Text("Vorschläge")
                    Spacer()
                    Button(action: { showingAddSuggestion = true }) {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                }) {
                    ForEach(settingsManager.suggestedIngredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                            Spacer()
                            if settingsManager.isIngredientExcluded(ingredient) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Button(action: {
                                    settingsManager.addExcludedIngredient(ingredient)
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                settingsManager.removeSuggestedIngredient(ingredient)
                            } label: {
                                Label("Löschen", systemImage: "trash")
                            }
                        }
                    }
                }
                
                Section(header: Text("Ausgeschlossene Zutaten")) {
                    if settingsManager.excludedIngredients.isEmpty {
                        Text("Keine ausgeschlossenen Zutaten")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(Array(settingsManager.excludedIngredients).sorted(), id: \.self) { ingredient in
                            HStack {
                                Text(ingredient)
                                Spacer()
                                Button(action: {
                                    settingsManager.removeExcludedIngredient(ingredient)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Informationen")) {
                    NavigationLink(destination: MarkdownView(resourceName: "tips_and_tricks", title: "Tipps & Tricks")) {
                        Label("Tipps & Tricks", systemImage: "lightbulb")
                    }
                    
                    NavigationLink(destination: MarkdownView(resourceName: "privacy_policy", title: "Datenschutz")) {
                        Label("Datenschutz", systemImage: "hand.raised")
                    }
                    
                    NavigationLink(destination: MarkdownView(resourceName: "terms_of_use", title: "Nutzungsbedingungen")) {
                        Label("Nutzungsbedingungen", systemImage: "doc.text")
                    }
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarItems(trailing: Button("Fertig") {
                dismiss()
            })
            .alert("Neue Standardzutat", isPresented: $showingAddSuggestion) {
                TextField("Zutat", text: $newSuggestion)
                Button("Abbrechen", role: .cancel) { }
                Button("Hinzufügen") {
                    if !newSuggestion.isEmpty {
                        settingsManager.addSuggestedIngredient(newSuggestion)
                        newSuggestion = ""
                    }
                }
            } message: {
                Text("Geben Sie eine neue Standardzutat ein")
            }
        }
    }
}

#Preview {
    SettingsView(showDeleteAlert: .constant(false))
}
