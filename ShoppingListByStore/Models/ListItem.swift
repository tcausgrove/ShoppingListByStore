//
//  ListItem.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 3/29/25.
//

import SwiftUI
import SwiftData

@Model
class ListItem: Identifiable {
    var name: String
    var hasCheck: Bool
    
    init(name: String = "Example item", hasCheck: Bool = false) {
        self.name = name
        self.hasCheck = hasCheck
    }
    
    func toggleCheck() {
        self.hasCheck.toggle()
    }
}
