import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @State private var isPurchasing = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Unbegrenzt Rezepte scannen")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Nur 0,99€ für 4 Wochen")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Features
                VStack(alignment: .leading, spacing: 15) {
                    SubscriptionFeatureRow(icon: "infinity", title: "Unbegrenzte Scans", description: "Scannen Sie so viele Rezepte wie Sie möchten")
                    SubscriptionFeatureRow(icon: "arrow.clockwise", title: "Jederzeit kündbar", description: "Keine Mindestlaufzeit, flexibel monatlich kündbar")
                    SubscriptionFeatureRow(icon: "checkmark.shield", title: "Keine Werbung", description: "Genießen Sie die App ohne störende Werbung")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 5)
                )
                
                Spacer()
                
                // Status
                if let expirationDate = subscriptionManager.subscriptionExpirationDate, subscriptionManager.isSubscribed {
                    Text("Premium aktiv bis \(expirationDate.formatted(date: .long, time: .omitted))")
                        .foregroundColor(.green)
                } else {
                    Text("\(subscriptionManager.remainingFreeScans) kostenlose Scans übrig")
                        .foregroundColor(.secondary)
                }
                
                // Purchase Button
                Button(action: {
                    Task {
                        isPurchasing = true
                        do {
                            try await subscriptionManager.purchase()
                            dismiss()
                        } catch {
                            if let subError = error as? SubscriptionError {
                                errorMessage = subError.localizedDescription
                            } else {
                                errorMessage = error.localizedDescription
                            }
                        }
                        isPurchasing = false
                    }
                }) {
                    HStack {
                        if isPurchasing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text(subscriptionManager.isSubscribed ? "Bereits abonniert" : "Jetzt freischalten")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(subscriptionManager.isSubscribed ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(subscriptionManager.isSubscribed || isPurchasing)
                .padding(.horizontal)
                
                // Terms
                Text("Mit dem Kauf stimmen Sie den Nutzungsbedingungen zu. Das Abo verlängert sich automatisch, kann aber jederzeit gekündigt werden.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Schließen") {
                        dismiss()
                    }
                }
            }
            .alert("Fehler", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let message = errorMessage {
                    Text(message)
                }
            }
        }
    }
}

struct SubscriptionFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview {
    SubscriptionView()
}
