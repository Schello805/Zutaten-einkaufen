import StoreKit
import SwiftUI

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    @Published var isSubscribed = false
    @Published var remainingFreeScans: Int {
        didSet {
            UserDefaults.standard.set(remainingFreeScans, forKey: "RemainingFreeScans")
        }
    }
    @Published var subscriptionExpirationDate: Date? {
        didSet {
            if let date = subscriptionExpirationDate {
                UserDefaults.standard.set(date, forKey: "SubscriptionExpirationDate")
            } else {
                UserDefaults.standard.removeObject(forKey: "SubscriptionExpirationDate")
            }
        }
    }
    
    private let initialFreeScans = 5
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        remainingFreeScans = UserDefaults.standard.integer(forKey: "RemainingFreeScans")
        if remainingFreeScans == 0 && !UserDefaults.standard.bool(forKey: "HasInitializedFreeScans") {
            remainingFreeScans = initialFreeScans
            UserDefaults.standard.set(true, forKey: "HasInitializedFreeScans")
        }
        
        if let date = UserDefaults.standard.object(forKey: "SubscriptionExpirationDate") as? Date {
            subscriptionExpirationDate = date
            isSubscribed = date > Date()
        }
        
        updateListenerTask = listenForTransactions()
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in StoreKit.Transaction.updates {
                await self.handle(updatedTransaction: result)
            }
        }
    }
    
    private func handle(updatedTransaction transaction: VerificationResult<StoreKit.Transaction>) async {
        guard case .verified(let transaction) = transaction else {
            return
        }
        
        if transaction.revocationDate == nil {
            await update(from: transaction)
        }
        
        await transaction.finish()
    }
    
    private func update(from transaction: StoreKit.Transaction) async {
        let expirationDate = transaction.expirationDate ?? Date()
        subscriptionExpirationDate = expirationDate
        isSubscribed = expirationDate > Date()
    }
    
    func canScan() -> Bool {
        if isSubscribed { return true }
        return remainingFreeScans > 0
    }
    
    func useFreeScan() {
        guard remainingFreeScans > 0 else { return }
        remainingFreeScans -= 1
    }
    
    func purchase() async throws {
        guard let product = try? await Product.products(for: ["biz.schellenberger.michael.Zutaten-einkaufen.subscription.4weeks"]).first else {
            throw SubscriptionError.productNotFound
        }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            guard case .verified(let transaction) = verification else {
                throw SubscriptionError.verificationFailed
            }
            await update(from: transaction)
            
        case .userCancelled:
            throw SubscriptionError.userCancelled
            
        case .pending:
            throw SubscriptionError.pending
            
        @unknown default:
            throw SubscriptionError.unknown
        }
    }
}

enum SubscriptionError: Error {
    case productNotFound
    case purchaseFailed
    case verificationFailed
    case userCancelled
    case pending
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .productNotFound:
            return "Produkt konnte nicht gefunden werden."
        case .purchaseFailed:
            return "Kauf konnte nicht abgeschlossen werden."
        case .verificationFailed:
            return "Verifizierung fehlgeschlagen."
        case .userCancelled:
            return "Kauf wurde abgebrochen."
        case .pending:
            return "Kauf wird verarbeitet."
        case .unknown:
            return "Ein unbekannter Fehler ist aufgetreten."
        }
    }
}
