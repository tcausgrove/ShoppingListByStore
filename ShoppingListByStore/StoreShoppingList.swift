//
//  ListItem.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import Foundation

struct ShoppingData: Codable, Equatable {
    var selectedStoreID: UUID
    var arrayOfStores: [StoreData]
    
//    static let example = ShoppingData(selectedStoreID: UUID(), arrayOfStores: [StoreData.example])
}

struct StoreData: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var items: [ListItem]
    
    static let example = StoreData(id: UUID(), name: "Store #2", items: [])
}

struct ListItem: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var hasCheck: Bool
    
    static let example = ListItem(id: UUID(), name: "More food", hasCheck: false)
}
