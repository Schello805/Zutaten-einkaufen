import Foundation
import SwiftUI

enum Category: String, Codable, CaseIterable {
    case produce = "Obst & Gemüse"
    case dairy = "Milchprodukte"
    case bakery = "Backwaren"
    case meat = "Fleisch & Fisch"
    case pantry = "Vorrat"
    case spices = "Gewürze"
    case oils = "Öle & Fette"
    case other = "Sonstiges"
    
    var icon: String {
        switch self {
        case .produce: return "🥕"
        case .dairy: return "🥛"
        case .bakery: return "🥖"
        case .meat: return "🥩"
        case .pantry: return "🥫"
        case .spices: return "🧂"
        case .oils: return "🧈"
        case .other: return "🛒"
        }
    }
    
    static func getSpecificIcon(for ingredient: String) -> String? {
        let mapping: [String: String] = [
            // Obst
            "apfel": "🍎",
            "äpfel": "🍎",
            "birne": "🍐",
            "birnen": "🍐",
            "banane": "🍌",
            "bananen": "🍌",
            "orange": "🍊",
            "orangen": "🍊",
            "zitrone": "🍋",
            "zitronen": "🍋",
            "mandarine": "🍊",
            "mandarinen": "🍊",
            "weintraube": "🍇",
            "weintrauben": "🍇",
            "erdbeere": "🍓",
            "erdbeeren": "🍓",
            "kiwi": "🥝",
            "kiwis": "🥝",
            "pfirsich": "🍑",
            "pfirsiche": "🍑",
            "melone": "🍈",
            "melonen": "🍈",
            "ananas": "🍍",
            
            // Gemüse
            "tomate": "🍅",
            "tomaten": "🍅",
            "karotte": "🥕",
            "karotten": "🥕",
            "möhre": "🥕",
            "möhren": "🥕",
            "kartoffel": "🥔",
            "kartoffeln": "🥔",
            "zwiebel": "🧅",
            "zwiebeln": "🧅",
            "knoblauch": "🧄",
            "salat": "🥬",
            "kopfsalat": "🥬",
            "gurke": "🥒",
            "gurken": "🥒",
            "paprika": "🫑",
            "brokkoli": "🥦",
            "aubergine": "🍆",
            "auberginen": "🍆",
            "mais": "🌽",
            "pilze": "🍄",
            "champignons": "🍄",
            
            // Backwaren
            "brot": "🍞",
            "brötchen": "🥖",
            "croissant": "🥐",
            "brezel": "🥨",
            "kuchen": "🍰",
            "torte": "🎂",
            "keks": "🍪",
            "kekse": "🍪",
            
            // Milchprodukte
            "milch": "🥛",
            "joghurt": "🫐",
            "käse": "🧀",
            "butter": "🧈",
            "sahne": "🥛",
            "quark": "🥛",
            
            // Eier
            "ei": "🥚",
            "eier": "🥚",
            
            // Fleisch
            "fleisch": "🥩",
            "steak": "🥩",
            "wurst": "🌭",
            "würstchen": "🌭",
            "schinken": "🥓",
            "speck": "🥓",
            "hähnchen": "🍗",
            "huhn": "🍗",
            "chicken": "🍗",
            
            // Fisch & Meeresfrüchte
            "fisch": "🐟",
            "lachs": "🐟",
            "thunfisch": "🐟",
            "garnelen": "🦐",
            "shrimps": "🦐",
            
            // Getränke
            "wasser": "💧",
            "mineralwasser": "💧",
            "saft": "🧃",
            "limonade": "🥤",
            "cola": "🥤",
            "bier": "🍺",
            "wein": "🍷",
            "kaffee": "☕️",
            "tee": "🫖",
            
            // Snacks
            "chips": "🥨",
            "schokolade": "🍫",
            "süßigkeiten": "🍬",
            "bonbons": "🍬",
            "nüsse": "🥜",
            "erdnüsse": "🥜",
            
            // Gewürze & Basics
            "salz": "🧂",
            "pfeffer": "🧂",
            "zucker": "🧂",
            "mehl": "🌾",
            "reis": "🍚",
            "nudeln": "🍝",
            "spaghetti": "🍝",
            "öl": "🫗",
            "olivenöl": "🫗",
            
            // Saucen & Dips
            "ketchup": "🍅",
            "mayonnaise": "🥚",
            "senf": "🌭",
            
            // Fertiggerichte
            "pizza": "🍕",
            "burger": "🍔",
            "pommes": "🍟",
            "döner": "🥙",
            "sushi": "🍱"
        ]
        
        return mapping[ingredient.lowercased()]
    }
    
    var color: Color {
        switch self {
        case .produce: return .green
        case .dairy: return .blue
        case .bakery: return .brown
        case .meat: return .red
        case .pantry: return .orange
        case .spices: return .purple
        case .oils: return .yellow
        case .other: return .gray
        }
    }
    
    static func detect(from item: String) -> Category {
        let lowercased = item.lowercased()
        
        // Milchprodukte
        if lowercased.contains("milch") || lowercased.contains("käse") || lowercased.contains("joghurt") || 
           lowercased.contains("sahne") || lowercased.contains("quark") || lowercased.contains("schmand") {
            return .dairy
        }
        
        // Fette & Öle
        if lowercased.contains("butter") || lowercased.contains("öl") || lowercased.contains("margarine") ||
           lowercased.contains("schmalz") {
            return .oils
        }
        
        // Gewürze
        if lowercased.contains("gewürz") || lowercased.contains("salz") || lowercased.contains("pfeffer") ||
           lowercased.contains("zimt") || lowercased.contains("curry") || lowercased.contains("paprika") ||
           lowercased.contains("kräuter") || lowercased.contains("basilikum") || lowercased.contains("oregano") {
            return .spices
        }
        
        // Backwaren
        if lowercased.contains("mehl") || lowercased.contains("brot") || lowercased.contains("brötchen") || 
           lowercased.contains("kuchen") || lowercased.contains("toast") || lowercased.contains("semmel") ||
           lowercased.contains("teig") {
            return .bakery
        }
        
        // Obst & Gemüse
        if lowercased.contains("apfel") || lowercased.contains("banane") || lowercased.contains("karotte") || 
           lowercased.contains("salat") || lowercased.contains("tomate") || lowercased.contains("gurke") ||
           lowercased.contains("zwiebel") || lowercased.contains("knoblauch") || lowercased.contains("obst") ||
           lowercased.contains("gemüse") || lowercased.contains("birne") || lowercased.contains("orange") ||
           lowercased.contains("zitrone") || lowercased.contains("kartoffel") || lowercased.contains("möhre") {
            return .produce
        }
        
        // Fleisch & Fisch
        if lowercased.contains("fleisch") || lowercased.contains("wurst") || lowercased.contains("fisch") ||
           lowercased.contains("schinken") || lowercased.contains("hähnchen") || lowercased.contains("rind") ||
           lowercased.contains("schwein") || lowercased.contains("lachs") || lowercased.contains("thunfisch") {
            return .meat
        }
        
        // Vorrat
        if lowercased.contains("dose") || lowercased.contains("konserve") || lowercased.contains("nudel") ||
           lowercased.contains("reis") || lowercased.contains("zucker") || lowercased.contains("mehl") ||
           lowercased.contains("müsli") || lowercased.contains("cornflakes") || lowercased.contains("sauce") {
            return .pantry
        }
        
        return .other
    }
}

struct Quantity: Codable, Equatable {
    var amount: Double
    var unit: String
    
    static func parse(from text: String) -> Quantity? {
        let pattern = #"(\d+(?:[.,]\d+)?)\s*([a-zA-ZäöüÄÖÜß]+)?"#
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        
        if let match = regex?.firstMatch(in: text, options: [], range: NSRange(text.startIndex..., in: text)) {
            if let amountRange = Range(match.range(at: 1), in: text) {
                let amountStr = text[amountRange].replacingOccurrences(of: ",", with: ".")
                if let amount = Double(amountStr) {
                    var unit: String? = nil
                    if match.numberOfRanges > 2, let unitRange = Range(match.range(at: 2), in: text) {
                        unit = String(text[unitRange])
                    }
                    return Quantity(amount: amount, unit: unit ?? "")
                }
            }
        }
        return nil
    }
    
    func toString() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            return "\(formattedAmount) \(unit)".trimmingCharacters(in: .whitespaces)
        }
        return "\(amount) \(unit)".trimmingCharacters(in: .whitespaces)
    }
    
    static func + (lhs: Quantity, rhs: Quantity) -> Quantity? {
        let normalizedLHS = normalizeUnit(lhs)
        let normalizedRHS = normalizeUnit(rhs)
        
        if normalizedLHS.unit == normalizedRHS.unit {
            return Quantity(amount: normalizedLHS.amount + normalizedRHS.amount, unit: normalizedLHS.unit)
        }
        return nil
    }
    
    private static func normalizeUnit(_ quantity: Quantity) -> Quantity {
        let unit = quantity.unit.lowercased().trimmingCharacters(in: .whitespaces)
        var amount = quantity.amount
        var normalizedUnit = unit
        
        switch unit {
        // Gewicht
        case "kg":
            amount *= 1000
            normalizedUnit = "g"
            
        // Volumen
        case "l":
            amount *= 1000
            normalizedUnit = "ml"
            
        // Löffel und Tassen
        case "el", "esslöffel", "essl":
            amount *= 15
            normalizedUnit = "ml"
        case "tl", "teelöffel", "teel":
            amount *= 5
            normalizedUnit = "ml"
        case "tasse", "tassen":
            amount *= 250
            normalizedUnit = "ml"
        case "becher":
            amount *= 200
            normalizedUnit = "ml"
        case "glas", "gläser":
            amount *= 200
            normalizedUnit = "ml"
            
        // Kleine Mengen
        case "prise", "prisen":
            amount *= 0.5
            normalizedUnit = "g"
        case "msp", "messerspitze", "messerspitzen":
            amount *= 0.5
            normalizedUnit = "g"
        case "schuss", "spritzer":
            amount *= 5
            normalizedUnit = "ml"
            
        // Stückzahlen
        case "stk", "stück", "st":
            normalizedUnit = "Stück"
        case "pkg", "packung", "packungen", "pckg", "pack":
            normalizedUnit = "Packung"
            
        default:
            break
        }
        
        return Quantity(amount: amount, unit: normalizedUnit)
    }
}

struct ItemQuantity: Codable, Identifiable {
    let id: UUID
    var quantity: Quantity
    var recipe: String
    
    init(id: UUID = UUID(), quantity: Quantity, recipe: String) {
        self.id = id
        self.quantity = quantity
        self.recipe = recipe
    }
}

struct GroceryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantities: [ItemQuantity]
    var category: Category
    var isChecked: Bool
    var dateAdded: Date
    var icon: String {
        // Erst prüfen ob es ein spezifisches Icon für die Zutat gibt
        if let specificIcon = Category.getSpecificIcon(for: name.lowercased()) {
            return specificIcon
        }
        
        // Ansonsten das Kategorie-Icon verwenden
        return category.icon
    }
    
    init(id: UUID = UUID(), name: String, quantity: Quantity? = nil, recipe: String = "", category: Category = .other, isChecked: Bool = false) {
        self.id = id
        self.name = name
        self.quantities = quantity.map { [ItemQuantity(quantity: $0, recipe: recipe)] } ?? []
        self.category = category
        self.isChecked = isChecked
        self.dateAdded = Date()
    }
    
    var totalQuantity: Quantity? {
        guard !quantities.isEmpty else { return nil }
        
        let firstQuantity = quantities[0].quantity
        var total = firstQuantity
        
        for i in 1..<quantities.count {
            if let sum = total + quantities[i].quantity {
                total = sum
            }
        }
        
        return total
    }
    
    mutating func addQuantity(_ quantity: Quantity, recipe: String) {
        quantities.append(ItemQuantity(quantity: quantity, recipe: recipe))
    }
    
    func formatQuantities() -> String {
        var result = ""
        
        for itemQuantity in quantities {
            if !result.isEmpty { result += "\n" }
            result += "\(itemQuantity.quantity.toString()) \(itemQuantity.recipe)"
        }
        
        if let total = totalQuantity, quantities.count > 1 {
            result += "\n= \(total.toString()) gesamt"
        }
        
        return result
    }
}
