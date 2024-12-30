import UIKit
import Vision

struct AnalysisResult: Codable {
    let ingredient: String
    let quantity: Double?
    let unit: String?
    let isIngredient: Bool
    
    private enum CodingKeys: String, CodingKey {
        case ingredient
        case quantity
        case unit
        case isIngredient
    }
    
    init(ingredient: String, quantity: Double?, unit: String?, isIngredient: Bool) {
        self.ingredient = ingredient
        self.quantity = quantity
        self.unit = unit
        self.isIngredient = isIngredient
    }
}

class TextAnalysisService {
    private let openAI = OpenAIService()
    
    private func createSystemPrompt() -> String {
        return """
        Du bist ein Assistent für die Analyse von Rezepten und Zutatenlisten. Extrahiere alle Zutaten mit ihren Mengen.
        Gib die Antwort als JSON-Array zurück. Jedes Element soll folgende Felder haben:
        - ingredient (String): Name der Zutat
        - quantity (Number): Menge (null wenn keine Angabe)
        - unit (String): Einheit (null wenn keine Angabe)
        - isIngredient (Boolean): Immer true
        
        Wichtig:
        - Normalisiere Einheiten (TL -> Teelöffel, EL -> Esslöffel)
        - Ignoriere Textpassagen die keine Zutaten sind
        - Halte die Antwort so kurz wie möglich
        - Keine zusätzlichen Kommentare oder Erklärungen
        """
    }
    
    private func createUserPrompt(for text: String) -> String {
        return "Extrahiere die Zutaten aus folgendem Text:\n\n\(text)"
    }
    
    func analyzeImage(_ image: UIImage) async throws -> [AnalysisResult] {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "TextAnalysis", code: 1, userInfo: [NSLocalizedDescriptionKey: "Konnte Bild nicht verarbeiten"])
        }
        
        print("🔍 Starte Textanalyse...")
        
        // Konfiguriere die Texterkennung
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["de-DE"]
        request.usesLanguageCorrection = true
        
        // Führe die Texterkennung durch
        let recognizedText: String = try await withCheckedThrowingContinuation { continuation in
            do {
                try requestHandler.perform([request])
                guard let observations = request.results else {
                    continuation.resume(throwing: NSError(domain: "TextAnalysis", code: 2, userInfo: [NSLocalizedDescriptionKey: "Keine Texterkennung möglich"]))
                    return
                }
                
                let recognizedStrings = observations.compactMap { observation in
                    return observation.topCandidates(1).first?.string
                }
                
                print("\n📝 Erkannter Text:")
                recognizedStrings.forEach { print("   • \($0)") }
                
                continuation.resume(returning: recognizedStrings.joined(separator: "\n"))
            } catch {
                continuation.resume(throwing: error)
            }
        }
        
        // Sende den kompletten Text an GPT-4
        let prompt = "\(createSystemPrompt())\n\n\(createUserPrompt(for: recognizedText))"
        
        if let response = try await openAI.sendPrompt(prompt) {
            print("\nGPT-4 Antwort: \(response)")
            
            // Versuche die JSON-Antwort zu extrahieren
            if let jsonStart = response.firstIndex(of: "["),
               let jsonEnd = response.lastIndex(of: "]") {
                let jsonString = String(response[jsonStart...jsonEnd])
                
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode([AnalysisResult].self, from: jsonString.data(using: .utf8) ?? Data())
                    return results.map { result in
                        AnalysisResult(
                            ingredient: result.ingredient,
                            quantity: result.quantity,
                            unit: result.unit,
                            isIngredient: true
                        )
                    }
                } catch {
                    print("Fehler beim Dekodieren der JSON-Antwort: \(error)")
                    throw error
                }
            } else {
                throw NSError(domain: "TextAnalysis", code: 3, userInfo: [NSLocalizedDescriptionKey: "Ungültiges Antwortformat von GPT-4"])
            }
        }
        
        return []
    }
}
