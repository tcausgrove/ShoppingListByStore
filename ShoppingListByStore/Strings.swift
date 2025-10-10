//
//  Strings.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 1/8/25.
//

import Foundation

// Strings in ContentView.swift

let alertTitle: String = NSLocalizedString("remove_item", comment: "Check whether we really want to remove items")
let alertDeleteText: String = NSLocalizedString("delete_item", comment: "Delete the item(s)")
let alertCancelText: String = NSLocalizedString("cancel_deletion", comment: "Don't delete the item(s)")
let accessibilityDeleteLabel: String = NSLocalizedString("acclabel_delete_checked_items", comment: "Accessibility string applied to trash can button")
let accessibilityStoreList: String = NSLocalizedString("acclabel_store_list", comment: "Let VoiceOver users know what this button is")


// Strings in ItemListView

let accessibilityBeforeItemName: String = NSLocalizedString("acclabel_item", comment: "Read by VoiceOver before item name")
let accessibilityNewItem: String = NSLocalizedString("acclabel_new_item", comment: "Accessibility string applied to plus button")
let accessibilityCheckMark: String = NSLocalizedString("acclabel_checked", comment: "Accessibility string applied to checkmark")
let accessibilityNewItemHint: String = NSLocalizedString("acchint_new_item", comment: "Accessibility hint applied to plus button")
//func accessibilityNewItemHint(storeName: String) -> String {
//    return (NSLocalizedString("Add new item to \(storeName) list", comment: "Accessibility hint applied to plus button"))
//}


// Strings in StoreNameView
let aboveStoreNames: String = NSLocalizedString("store_list", comment: "Appears above the list of store names")
let accessibilityNewStoreName: String = NSLocalizedString("acclabel_renaming_store_new_name", comment: "Used when renaming a store")
let accessibilityPlusStoreButton: String = NSLocalizedString("acclabel_new_store", comment: "Accessibility label applied to add store plus button")
let accessibilityHintPlusStoreButton: String = NSLocalizedString("acchint_new_store_name", comment: "Accessibility hint applied to add store plus button")
