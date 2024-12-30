import SwiftUI

struct MarkdownView: View {
    let resourceName: String
    let title: String
    @Environment(\.colorScheme) var colorScheme
    @State private var markdownContent: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if !markdownContent.isEmpty {
                    Text(try! AttributedString(markdown: markdownContent, options: AttributedString.MarkdownParsingOptions(
                        interpretedSyntax: .inlineOnlyPreservingWhitespace
                    )))
                    .markdownStyle()
                    .padding(.horizontal)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(title)
        .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
        .onAppear {
            loadMarkdownContent()
        }
    }
    
    private func loadMarkdownContent() {
        if let path = Bundle.main.path(forResource: resourceName, ofType: "md"),
           let content = try? String(contentsOfFile: path, encoding: .utf8) {
            markdownContent = content
        }
    }
}

// Markdown Styling
extension Text {
    func markdownStyle() -> some View {
        self.textSelection(.enabled)
            .font(.body)
            .lineSpacing(8)
            .fixedSize(horizontal: false, vertical: true)
    }
}

// Preview
struct MarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MarkdownView(resourceName: "tips_and_tricks", title: "Tipps & Tricks")
        }
    }
}
