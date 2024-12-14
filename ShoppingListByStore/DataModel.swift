//
//  ListItem.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import Foundation

struct ShoppingData: Codable {
    var selectedStoreID: UUID
    var arrayOfStores: [StoreData]
    
    static let example = ShoppingData(selectedStoreID: UUID(), arrayOfStores: [StoreData.example])
}

struct StoreData: Codable, Identifiable {
    var id: UUID
    var name: String
    var items: [ListItem]
    
    static let example = StoreData(id: UUID(), name: "Store #2", items: [])
}

struct ListItem: Codable, Identifiable {
    var id = UUID()
    var name: String
    var hasCheck: Bool
    
    static let example = ListItem(name: "More food", hasCheck: false)
}
