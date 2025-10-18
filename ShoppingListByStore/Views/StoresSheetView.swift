//
//  StoresSheetView.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 3/29/25.
//

import SwiftUI
import SwiftData
import Defaults

struct StoresSheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Default(.selectedStoreIDKey) var selectedStoreID
    @Query var theStores: [StoreData]
    
    @State private var addingStore: Bool = false
    @State private var newStoreName = ""
    @FocusState var editingFocused: Bool

    var body: some View {
        VStack {
            Text("List of stores")
                .font(.title2)
            List {
                ForEach(theStores, id: \.self) { store in
                    HStack {
                        StoreNameView(previousStore: store)
//                        Text("\(store.name)")
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedStoreID = store.id
                        dismiss()
                    }
                }
                .onDelete(perform: deleteStores)
                if addingStore {
                    addingStoreView
                } else {
                    Button(
                        action: { addingStore.toggle() },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
        }
    }
    
    var addingStoreView: some View {
        TextField("", text: $newStoreName)
            .onAppear(perform: { editingFocused = true })
            .focused($editingFocused)
            .onSubmit {
                if !newStoreName.isEmpty {
                    makeNewStore(newStoreName: newStoreName)
                }
                addingStore = false
                newStoreName = ""
            }
    }
    
    func deleteStores(_ indexSet: IndexSet) {
        var wasSelected: Bool = false
        
        for index in indexSet {
            let storeToDelete = theStores[index]
            wasSelected = storeToDelete.id == selectedStoreID
            modelContext.delete(storeToDelete)
        }
        
        do {
            try  modelContext.save()
        } catch {
            print("Store count may not be correct")
        }
        if theStores.count == 0 {
            makeNewStore(newStoreName: "First store")
        } else {
            if wasSelected { selectedStoreID =  theStores[0].id }
        }
    }
    
    func makeNewStore(newStoreName: String) {
        let newStore = StoreData(id: UUID(), name: newStoreName, items: [])
        selectedStoreID = newStore.id
        modelContext.insert(newStore)
    }
 }

#Preview {
    StoresSheetView()
}
