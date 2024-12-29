# 🛒 Zutaten Einkaufen

Eine intelligente iOS-App zum Scannen von Rezepten und automatischen Erstellen von Einkaufslisten. Die App nutzt modernste KI-Technologie, um Zutaten aus Fotos zu erkennen und zu einer übersichtlichen Einkaufsliste zusammenzufassen.

![App Screenshot](screenshots/app_preview.png)

## ✨ Features

- 📸 **Rezept-Scanner**: Fotografieren Sie Rezepte und lassen Sie die Zutaten automatisch erkennen
- 🤖 **KI-gestützte Erkennung**: Präzise Texterkennung und Zutatenerkennung mit GPT-4
- 📝 **Intelligente Listen**: Automatisches Zusammenfassen gleicher Zutaten aus verschiedenen Rezepten
- 🎨 **Kategorisierung**: Übersichtliche Sortierung der Zutaten nach Kategorien
- 🔄 **Ausschluss-System**: Definieren Sie Grundzutaten, die Sie immer zuhause haben
- 📱 **Moderne UI**: Intuitive SwiftUI-Benutzeroberfläche
- 📤 **Teilen-Funktion**: Einkaufslisten einfach per Message oder Mail teilen

## 🚀 Installation

1. Klonen Sie das Repository:
```bash
git clone https://github.com/yourusername/zutaten-einkaufen.git
```

2. Öffnen Sie das Projekt in Xcode:
```bash
cd zutaten-einkaufen
open "Zutaten einkaufen.xcodeproj"
```

3. Erstellen Sie die Konfigurationsdatei:
```bash
cp Templates/Config.swift.template "Zutaten einkaufen/Config.swift"
```

4. Bearbeiten Sie `Config.swift` und fügen Sie Ihre API-Schlüssel ein:
```swift
enum Config {
    static let openAIKey = "Ihr-API-Schlüssel"
    static let openAIOrganization = "Ihre-Organizations-ID"  // Optional
    // ...
}
```

5. Bauen und starten Sie die App in Xcode

> ⚠️ **Wichtig**: 
> - Committen Sie niemals Ihre `Config.swift` Datei mit echten API-Schlüsseln!
> - Die Datei ist bereits in `.gitignore` aufgeführt und sollte nicht im Repository erscheinen.
> - Bewahren Sie Ihre API-Schlüssel sicher auf und teilen Sie sie nicht.

## ⚙️ Technische Anforderungen

- iOS 16.0 oder höher
- Xcode 15.0 oder höher
- Swift 5.9
- OpenAI API-Schlüssel für GPT-4

## 🏗 Architektur

Die App folgt der MVVM-Architektur und verwendet moderne iOS-Technologien:

- **SwiftUI**: Für die gesamte Benutzeroberfläche
- **Combine**: Für reaktive Programmierung
- **VisionKit**: Für die Dokumentenerkennung
- **OpenAI GPT-4**: Für die Zutatenerkennung
- **UserDefaults**: Für die persistente Datenspeicherung

## 📱 Hauptkomponenten

- `ContentView`: Hauptansicht mit Einkaufsliste
- `ScannerView`: Kamera-Interface für Rezeptscans
- `TextAnalysisService`: KI-gestützte Texterkennung
- `ShoppingListViewModel`: Geschäftslogik für die Einkaufsliste
- `GroceryItem`: Datenmodell für Zutaten
- `SettingsView`: Verwaltung von Ausschlüssen und Einstellungen

## 🔒 Datenschutz

- Alle Daten werden ausschließlich lokal gespeichert
- Keine Weitergabe persönlicher Informationen
- Verschlüsselte API-Kommunikation
- Temporäre Bildverarbeitung ohne dauerhafte Speicherung

## 🤝 Beitragen

Beiträge sind willkommen! Bitte beachten Sie:

1. Fork Sie das Repository
2. Erstellen Sie einen Feature-Branch (`git checkout -b feature/AmazingFeature`)
3. Commit Sie Ihre Änderungen (`git commit -m 'Add some AmazingFeature'`)
4. Push Sie den Branch (`git push origin feature/AmazingFeature`)
5. Öffnen Sie einen Pull Request

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe [LICENSE](LICENSE) für Details.

## 🙏 Danksagung

- OpenAI für die GPT-4 API
- Apple für SwiftUI und VisionKit
- Alle Mitwirkenden und Tester

## 📞 Kontakt

Michael Schellenberger - [@IhrTwitterHandle](https://twitter.com/IhrTwitterHandle)

Projekt-Link: [https://github.com/yourusername/zutaten-einkaufen](https://github.com/yourusername/zutaten-einkaufen)
