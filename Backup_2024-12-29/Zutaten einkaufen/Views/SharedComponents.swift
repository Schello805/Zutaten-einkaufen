import SwiftUI

struct CategoryIcon: View {
    let category: Category
    
    var body: some View {
        Image(systemName: category.icon)
            .foregroundColor(.blue)
    }
}

struct FeatureRow: View {
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
        .padding(.horizontal)
    }
}

struct EmptyStateView: View {
    @Binding var showingScanner: Bool
    @State private var showAnimation = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .scaleEffect(showAnimation ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: showAnimation)
            
            Text("Willkommen bei Ihrer Einkaufsliste!")
                .font(.title2)
                .fontWeight(.bold)
                .opacity(showAnimation ? 1 : 0)
                .offset(y: showAnimation ? 0 : 20)
            
            VStack(alignment: .leading, spacing: 15) {
                AnimatedFeatureRow(
                    icon: "camera.fill",
                    title: "Rezepte scannen",
                    description: "Fotografieren Sie ein Rezept ab, um die Zutaten automatisch zu erfassen",
                    delay: 0.2
                )
                
                AnimatedFeatureRow(
                    icon: "checkmark.circle.fill",
                    title: "Liste verwalten",
                    description: "Löschen und sortieren Sie Ihre Zutaten",
                    delay: 0.4
                )
                
                AnimatedFeatureRow(
                    icon: "square.and.arrow.up",
                    title: "Liste teilen",
                    description: "Teilen Sie Ihre Einkaufsliste mit anderen",
                    delay: 0.6
                )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 5)
            )
            
            Button {
                showingScanner = true
            } label: {
                HStack {
                    Image(systemName: "camera.fill")
                        .frame(width: 30, alignment: .center)
                    Text("Rezept scannen")
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .padding()
        .multilineTextAlignment(.center)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showAnimation = true
            }
        }
    }
}

struct AnimatedFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let delay: Double
    
    @State private var isVisible = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30, alignment: .center)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(delay)) {
                isVisible = true
            }
        }
    }
}
