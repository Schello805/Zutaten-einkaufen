import SwiftUI
import MessageUI

struct ShareOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    let viewModel: ShoppingListViewModel
    @State private var showingMailView = false
    @State private var showingShareSheet = false
    @State private var showingCopiedAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Teilen über")) {
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        ShareOptionRow(
                            icon: "square.and.arrow.up",
                            title: "Teilen",
                            subtitle: "Über iOS Teilen-Menü senden"
                        )
                    }
                    
                    if MFMailComposeViewController.canSendMail() {
                        Button(action: {
                            showingMailView = true
                        }) {
                            ShareOptionRow(
                                icon: "envelope",
                                title: "Per E-Mail senden",
                                subtitle: "Als formatierten Text versenden"
                            )
                        }
                    }
                    
                    Button(action: {
                        UIPasteboard.general.string = viewModel.shareList()
                        showingCopiedAlert = true
                    }) {
                        ShareOptionRow(
                            icon: "doc.on.doc",
                            title: "In Zwischenablage kopieren",
                            subtitle: "Text zum Einfügen speichern"
                        )
                    }
                }
                
                Section(header: Text("Vorschau")) {
                    Text(viewModel.shareList())
                        .font(.system(.body, design: .monospaced))
                        .padding()
                }
            }
            .navigationTitle("Liste teilen")
            .navigationBarItems(trailing: Button("Fertig") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingMailView) {
                MailView(content: viewModel.shareList())
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(activityItems: [viewModel.shareList()])
            }
            .alert(isPresented: $showingCopiedAlert) {
                Alert(
                    title: Text("Kopiert!"),
                    message: Text("Die Einkaufsliste wurde in die Zwischenablage kopiert."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ShareOptionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct MailView: UIViewControllerRepresentable {
    let content: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setSubject("Einkaufsliste")
        vc.setMessageBody(content, isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                 didFinishWith result: MFMailComposeResult,
                                 error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
