//
//  ContentView-ViewModel.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var shoppingData: ShoppingData
    @Published var userError: UserError? = nil

    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedShoppingList")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            shoppingData = try JSONDecoder().decode(ShoppingData.self, from: data)
            userError = nil
        } catch {
            let id = UUID()
            let storeData = StoreData(id: id, name: defaultStoreName, items: [])
            shoppingData = ShoppingData(selectedStoreID: id, arrayOfStores: [storeData])
//            userError = UserError.failedLoading
        }
    }
    
    var returnStoreNames: [String] {
        var storeNames: [String] = []
        for store in shoppingData.arrayOfStores {
            storeNames.append(store.name)
        }
        return storeNames
    }
    
    var selectedStore: StoreData {
        let theStore = shoppingData.arrayOfStores.first(where: { $0.id == shoppingData.selectedStoreID }) ?? StoreData.example
        return theStore
    }
        
    func addStore(newStoreName: String) {
        let id = UUID()
        let newStore = StoreData(id: id, name: newStoreName, items: [])
        shoppingData.arrayOfStores.append(newStore)
        shoppingData.selectedStoreID = id
        save()
    }
    
    func changeSelectedStore(selectedStoreName: String) {
        let theStore = shoppingData.arrayOfStores.first(where: { $0.name == selectedStoreName })
        shoppingData.selectedStoreID = theStore?.id ?? StoreData.example.id
    }
    
    func returnItemsString(selectedStoreName: String) -> String {
        let theStore = shoppingData.arrayOfStores.first(where: { $0.name == selectedStoreName })
        var itemString = ""
        if theStore == nil {
            return "List not available"
        }
        else {
            for item in theStore!.items {
                itemString += "- \(item.name)"
                if item.hasCheck {
                    itemString += " (checked)\n"
                } else {
                    itemString += "\n"
                }
            }
            return itemString
        }
    }
    
    func renameStore(oldStoreName: String, newStoreName: String) {
        let theStoreIndex = shoppingData.arrayOfStores.firstIndex(where: { $0.name == oldStoreName })
        
        if theStoreIndex != nil {
            shoppingData.arrayOfStores[theStoreIndex!].name = newStoreName
        } else {
        }
    }
    
    func deleteStores(indexSet: IndexSet) {
        for index in indexSet {
            // check whether we are deleting the current store
            if shoppingData.arrayOfStores[index].id == selectedStore.id {
                let newStoreIndex = max(0, index - 1)  // set new selected store to next one UP the list (or zero, if deleting the top one)
                shoppingData.selectedStoreID = shoppingData.arrayOfStores[newStoreIndex].id
            }
            shoppingData.arrayOfStores.remove(at: index)
        }
        if shoppingData.arrayOfStores.isEmpty {
            let id = UUID()
            let storeData = StoreData(id: id, name: defaultStoreName, items: [])
            shoppingData = ShoppingData(selectedStoreID: id, arrayOfStores: [storeData])
        }
        save()
    }
    
    func addItem(name: String) {
        if let storeIndex = shoppingData.arrayOfStores.firstIndex(where: { $0.id == selectedStore.id } ) {
            var newItemList = shoppingData.arrayOfStores[storeIndex].items
            let item = ListItem(id: UUID(), name: name, hasCheck: false)
            newItemList.append(item)
            shoppingData.arrayOfStores[storeIndex].items = newItemList
        }
        save()
    }
    
    func deleteItemsByIndexSet(indexSet: IndexSet) {
        if let storeIndex = shoppingData.arrayOfStores.firstIndex(where: { $0.id == selectedStore.id } ) {
            var newItemList = shoppingData.arrayOfStores[storeIndex].items
            newItemList.remove(atOffsets: indexSet)
            shoppingData.arrayOfStores[storeIndex].items = newItemList
            save()
        }
    }
    
    func deleteItem(item: ListItem) {
        if let storeIndex = shoppingData.arrayOfStores.firstIndex(where: { $0.id == selectedStore.id } ) {
            var newItemList = shoppingData.arrayOfStores[storeIndex].items
            guard let index = newItemList.firstIndex(where: { $0.id == item.id }) else { return }
            newItemList.remove(at: index)
            shoppingData.arrayOfStores[storeIndex].items = newItemList
        }
        save()
    }
    
    func rearrangeItems(from source: IndexSet, to destination: Int) {
        if let storeIndex = shoppingData.arrayOfStores.firstIndex(where: { $0.id == selectedStore.id } ) {
            var newItemList = shoppingData.arrayOfStores[storeIndex].items
            newItemList.move(fromOffsets: source, toOffset: destination)
            shoppingData.arrayOfStores[storeIndex].items = newItemList
        }
        save()
    }

    func rearrangeStores(from source: IndexSet, to destination: Int) {
            var newStoreList = shoppingData.arrayOfStores
            newStoreList.move(fromOffsets: source, toOffset: destination)
            shoppingData.arrayOfStores = newStoreList
        save()
    }
    
    func clearItems() {
        for item in selectedStore.items {
            if item.hasCheck {
                deleteItem(item: item)
            }
        }
        save()
    }
    
    func toggleCheck(item: ListItem) {
        if let store = shoppingData.arrayOfStores.firstIndex(where: { $0.id == selectedStore.id } ) {
            if let index = selectedStore.items.firstIndex(where: { $0.id == item.id }) {
                var newItem = selectedStore.items[index]
                newItem.hasCheck.toggle()
                shoppingData.arrayOfStores[store].items[index] = newItem
            }
            save()
        }
    }
    
    func checksExistForStore(store: StoreData) -> Bool {
        for item in store.items {
            if item.hasCheck  { return true }
        }
        return false
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(shoppingData)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            userError = nil
        } catch {
            userError = UserError.failedSaving
        }
    }
}
