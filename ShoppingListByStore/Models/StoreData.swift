//
//  StoreData.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 3/29/25.
//

import SwiftUI
import SwiftData
import Defaults

@Model
class StoreData: Identifiable {
    var id: UUID
    var name: String
//    var isSelected: Bool
    @Relationship(deleteRule: .cascade) var items: [ListItem]
    
    var example: StoreData {
        return .init(id: UUID(), name: "Example Store", items: [])
    }
    
    init(id: UUID, name: String, items: [ListItem]) {
        self.name = name
//        self.isSelected = isSelected
        self.items = items
        self.id = id
    }
    
    public static func selectedStore(with modelContext: ModelContext) -> StoreData {
        if let result = try! modelContext.fetch(FetchDescriptor<StoreData>()).first(where: { $0.id == Defaults[.selectedStoreIDKey] }) {
            return result
        } else {
            let newStore = StoreData(id: UUID(), name: "My first store", items: [])
            Defaults[.selectedStoreIDKey] = newStore.id
            modelContext.insert(newStore)
            return newStore
        }
    }
    
    public static func returnItemsString(with modelContext: ModelContext) -> String {
        let theStore = StoreData.selectedStore(with: modelContext)
        var itemString = ""
        
        for item in theStore.items {
            itemString += "- \(item.name)"
            if item.hasCheck {
                itemString += " (checked)\n"
            } else {
                itemString += "\n"
            }
        }
        return itemString
    }
    
    public static func appendNewItem(to store: StoreData, with newItem: ListItem, with modelContext: ModelContext) {
        store.items.append(newItem)
        try? modelContext.save()
    }
}
