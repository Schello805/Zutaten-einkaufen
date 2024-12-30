import Foundation

class OpenAIService {
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    private let organizationId = "org-5V6lQjMtKPFaiggY1o8IwRbg"
    
    func sendPrompt(_ prompt: String) async throws -> String? {
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(Config.openAIToken)", forHTTPHeaderField: "Authorization")
        request.setValue(organizationId, forHTTPHeaderField: "OpenAI-Organization")
        
        let messages: [[String: Any]] = [
            ["role": "system", "content": "Du bist ein präziser Assistent für Zutatenlisten. Antworte nur mit dem geforderten JSON."],
            ["role": "user", "content": "Extrahiere die Zutaten aus diesem Text als JSON-Array (wie im Format beschrieben):\n\n\(prompt)"]
        ]
        
        let payload: [String: Any] = [
            "model": "gpt-4",
            "messages": messages,
            "temperature": 0.3,
            "max_tokens": 800,
            "top_p": 0.9,
            "presence_penalty": 0,
            "frequency_penalty": 0
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        request.httpBody = jsonData
        
        print("\n🤖 Sende GPT-4 Anfrage...")
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Debug-Ausgabe für alle Antworten
        if let responseStr = String(data: data, encoding: .utf8) {
            print("📝 API Antwort: \(responseStr)")
            
            if responseStr.contains("insufficient_quota") {
                print("⚠️ API Quota erschöpft")
                throw URLError(.userAuthenticationRequired)
            }
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            print("❌ HTTP Fehler: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let choices = json["choices"] as? [[String: Any]],
           let firstChoice = choices.first,
           let message = firstChoice["message"] as? [String: Any],
           let content = message["content"] as? String {
            // Extrahiere nur den JSON-Teil
            if let jsonStart = content.firstIndex(of: "["),
               let jsonEnd = content.lastIndex(of: "]") {
                let jsonString = String(content[jsonStart...jsonEnd])
                print("\nExtrahierte JSON: \(jsonString)")
                return jsonString
            }
        }
        
        return nil
    }
}
