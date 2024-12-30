# AI Assistant Information für Zutaten Einkaufen App

## Projekt-Überblick
- **App Name**: Zutaten Einkaufen
- **Zweck**: Rezepte scannen und Einkaufslisten erstellen
- **Plattform**: iOS
- **Sprache**: Swift
- **Architektur**: MVVM

## Kern-Features
1. **Rezept-Scanner**:
   - Verwendet OpenAI API für Texterkennung
   - Extrahiert Zutaten und Mengen
   - Unterstützt verschiedene Einheiten

2. **Einkaufsliste**:
   - Automatische Kategorisierung
   - Mengenberechnung und -aggregation
   - Manuelles Hinzufügen möglich

3. **Premium-Features**:
   - 5 kostenlose Scans
   - Abo-Modell (0,99€/4 Wochen)
   - Unbegrenzte Scans für Premium

4. **Widget**:
   - Kleine und mittlere Größe
   - Zeigt Fortschritt und offene Artikel
   - Automatische Aktualisierung

## Wichtige Dateien
- `ContentView.swift`: Hauptansicht
- `GroceryItem.swift`: Datenmodell für Artikel
- `ShoppingListViewModel.swift`: Business Logic
- `StoreConfig.swift`: In-App Purchase Konfiguration
- `SubscriptionManager.swift`: Abo-Verwaltung

## APIs und Services
- **OpenAI API**: Für Texterkennung und -analyse
- **StoreKit**: Für In-App Purchases
- **WidgetKit**: Für Home Screen Widget

## Datenschutz
- Lokale Datenspeicherung
- Temporäre OpenAI API Nutzung
- Keine dauerhafte Cloud-Speicherung

## Bekannte Besonderheiten
1. Einheitenumrechnung unterstützt:
   - Gewichte (g, kg)
   - Volumen (ml, l)
   - Küchenmaße (EL, TL, Tasse)

2. Kategorien mit spezifischen Icons für:
   - Obst & Gemüse
   - Milchprodukte
   - Backwaren
   - Fleisch & Fisch
   - Vorrat
   - Getränke

## Detaillierte View-Struktur

### 1. ContentView
**Datei**: `ContentView.swift`
**Zweck**: Hauptansicht der App
**Features**:
- Navigation Stack mit Toolbar
- Einkaufsliste mit Kategorien
- Drag & Drop Unterstützung
- Swipe-Aktionen für Items
- Plus-Button für manuelle Eingabe
- Kamera-Button für Scan
- Share-Button für Export
- Settings-Button für Einstellungen

**Besonderheiten**:
- Verwendet `ShoppingListViewModel`
- Unterstützt Dark/Light Mode
- Animierte Übergänge
- Kontextmenüs für Items
- Dynamische Kategoriesortierung

### 2. CameraView
**Datei**: `CameraView.swift`
**Zweck**: Kamerainterface für Rezeptscans
**Features**:
- Live-Kameravorschau
- Fokus- und Belichtungssteuerung
- Blitz-Kontrolle
- Foto-Aufnahme
- Bildanalyse-Integration

**Besonderheiten**:
- Prüft Kamera-Berechtigungen
- Optimiert für Texterfassung
- Stabilisierungsmodus
- Fehlerbehandlung
- Fortschrittsanzeige während Analyse

### 3. SettingsView
**Datei**: `SettingsView.swift`
**Zweck**: App-Einstellungen
**Features**:
- Kategorieverwaltung
- Sortierungsoptionen
- Darstellungsoptionen
- App-Informationen
- Datenschutz/Impressum
- Premium-Status

**Besonderheiten**:
- Persistente Einstellungen
- Dynamische Einstellungslisten
- In-App Links
- Version/Build-Info
- Premium-Upgrade Option

### 4. ShareOptionsView
**Datei**: `ShareOptionsView.swift`
**Zweck**: Teilen der Einkaufsliste
**Features**:
- Verschiedene Export-Formate
- Teilen via System-Sheet
- Kopieren in Zwischenablage
- Format-Vorschau
- Kategorie-Filter

**Besonderheiten**:
- Markdown-Export
- Formatierte Listen
- Emoji-Support
- Kategoriegruppen
- Mengeneinheiten-Formatierung

### 5. SubscriptionView
**Datei**: `SubscriptionView.swift`
**Zweck**: Premium-Funktionen und Abo
**Features**:
- Feature-Übersicht
- Preis-Anzeige
- Kauf-Button
- Status-Anzeige
- Restore-Funktion

**Besonderheiten**:
- StoreKit Integration
- Fehlerbehandlung
- Lokalisierte Preise
- Verbleibende Gratis-Scans
- Ablaufdatum-Anzeige

### 6. MarkdownView
**Datei**: `MarkdownView.swift`
**Zweck**: Markdown-Rendering
**Features**:
- Markdown-Parsing
- Formatierte Textanzeige
- Link-Handling
- Scrolling
- Selektierbarer Text

**Besonderheiten**:
- Unterstützt verschiedene Markdown-Elemente
- Anpassbare Stile
- Dark Mode Support
- Dynamische Schriftgrößen
- Barrierefreiheit

## View-Hierarchie
```
ContentView
├── NavigationStack
│   ├── ShoppingListView (in ContentView)
│   ├── CameraView
│   ├── SettingsView
│   │   └── SubscriptionView
│   └── ShareOptionsView
└── MarkdownView (verwendet in verschiedenen Kontexten)
```

## View-Kommunikation
- **EnvironmentObjects**:
  - `ShoppingListViewModel`
  - `SubscriptionManager`
  
- **StateObjects**:
  - Lokale View-States
  - Kamera-Controller
  - Share-Controller
  
- **Bindings**:
  - Listen-Items
  - Einstellungen
  - Modal-States

## UI/UX Besonderheiten
1. **Konsistente Gestaltung**:
   - System-Fonts
   - Standard iOS Spacing
   - Native Navigationselemente

2. **Barrierefreiheit**:
   - VoiceOver Support
   - Dynamische Schriftgrößen
   - Ausreichende Kontrastwerte

3. **Performance**:
   - Lazy Loading für Listen
   - Effiziente Bildverarbeitung
   - Optimierte Animationen

4. **Fehlerbehandlung**:
   - Benutzerfreundliche Fehlermeldungen
   - Wiederherstellungsoptionen
   - Offline-Unterstützung

## Zukünftige Entwicklung
Mögliche Erweiterungen:
1. Rezeptverwaltung
2. Mehrere Einkaufslisten
3. iCloud-Synchronisation
4. Großes Widget
5. Interaktive Widget-Funktionen

## Support
- Datenschutzerklärung: PRIVACY.md
- Nutzungsbedingungen: TERMS.md
- App Store Info: APPSTORE.md

## Wichtige Hinweise für KI-Assistenten
1. Die App verwendet sensible APIs (OpenAI)
2. Premium-Features sind durch StoreKit implementiert
3. Beachte Datenschutz bei Änderungen
4. Prüfe Icon-Zuordnungen bei neuen Zutaten
5. Berücksichtige Einheitenumrechnung bei Änderungen
