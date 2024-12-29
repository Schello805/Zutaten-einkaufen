import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GroceryListEntry {
        GroceryListEntry(date: Date(), items: [], progress: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (GroceryListEntry) -> ()) {
        let entry = GroceryListEntry(date: Date(), items: loadItems(), progress: calculateProgress())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [GroceryListEntry(date: Date(), items: loadItems(), progress: calculateProgress())]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func loadItems() -> [GroceryItem] {
        if let data = UserDefaults.standard.data(forKey: "groceryItems"),
           let items = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            return items.sorted { !$0.isChecked && $1.isChecked }
        }
        return []
    }
    
    private func calculateProgress() -> Double {
        let items = loadItems()
        guard !items.isEmpty else { return 0 }
        let checkedItems = items.filter { $0.isChecked }.count
        return Double(checkedItems) / Double(items.count)
    }
}

struct GroceryListEntry: TimelineEntry {
    let date: Date
    let items: [GroceryItem]
    let progress: Double
}

struct GroceryListWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            Text("Nicht unterstützte Größe")
        }
    }
}

struct SmallWidgetView: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "cart")
                    .font(.title2)
                Text("Einkaufsliste")
                    .font(.headline)
            }
            
            if entry.items.isEmpty {
                Text("Keine Artikel")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ProgressView(value: entry.progress) {
                    Text("\(Int(entry.progress * 100))%")
                        .font(.caption2)
                }
                
                Text("\(entry.items.filter { !$0.isChecked }.count) übrig")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}

struct MediumWidgetView: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "cart")
                    .font(.title2)
                Text("Einkaufsliste")
                    .font(.headline)
                Spacer()
                if !entry.items.isEmpty {
                    Text("\(Int(entry.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if entry.items.isEmpty {
                Text("Keine Artikel")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ProgressView(value: entry.progress)
                    .padding(.vertical, 2)
                
                ForEach(entry.items.prefix(3)) { item in
                    HStack {
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isChecked ? .green : .gray)
                        Text(item.name)
                            .font(.caption)
                            .lineLimit(1)
                        if let quantity = item.quantity {
                            Spacer()
                            Text(quantity.toString())
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if entry.items.count > 3 {
                    Text("+ \(entry.items.count - 3) weitere")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

@main
struct GroceryListWidget: Widget {
    let kind: String = "GroceryListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GroceryListWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Einkaufsliste")
        .description("Zeigt deine aktuelle Einkaufsliste an.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
