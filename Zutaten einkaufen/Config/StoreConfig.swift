import Foundation

enum StoreConfig {
    static let bundleId = "biz.schellenberger.michael.Zutaten-einkaufen"
    
    enum Products {
        static let subscription4Weeks = "\(bundleId).subscription.4weeks"
        
        static var all: [String] {
            [subscription4Weeks]
        }
    }
    
    enum PriceFormatting {
        static let locale = Locale(identifier: "de_DE")
        static let currencyCode = "EUR"
    }
    
    enum SubscriptionDuration {
        static let days = 28 // 4 weeks
    }
    
    enum Trial {
        static let freeScans = 5
    }
}
