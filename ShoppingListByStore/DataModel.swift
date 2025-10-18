//
//  ListItem.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import Foundation

struct LegacyShoppingData: Codable {
    var selectedStoreID: UUID
    var arrayOfStores: [LegacyStoreData]
    
    static let example = LegacyShoppingData(selectedStoreID: UUID(), arrayOfStores: [LegacyStoreData.example])
}

struct LegacyStoreData: Codable, Identifiable {
    var id: UUID
    var name: String
    var items: [LegacyListItem]
    
    static let example = LegacyStoreData(id: UUID(), name: "Store #2", items: [])
}

struct LegacyListItem: Codable, Identifiable {
    var id = UUID()
    var name: String
    var hasCheck: Bool
    
    static let example = LegacyListItem(name: "More food", hasCheck: false)
}
