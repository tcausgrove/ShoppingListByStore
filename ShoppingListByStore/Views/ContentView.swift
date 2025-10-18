//
//  ContentView.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 3/29/25.
//

import SwiftUI
import SwiftData
import Defaults

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var theStores: [StoreData]
    @Default(.selectedStoreIDKey) var selectedStoreID
    
    @State var isShowingStoreSheet: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        VStack {
            AppHeaderView()
            NavigationView {
                ListItemView(store: StoreData.selectedStore(with: modelContext))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading, content: {
                            // The delete (trashcan) navigation item
                            trashCanAction
                        })
                        ToolbarItem(placement: .navigationBarLeading, content: {
                            let sharedItem = StoreData.returnItemsString(with: modelContext)
                            let theStore = StoreData.selectedStore(with: modelContext)
                            let previewText = "Items for \(theStore.name)"
                            ShareLink(item: sharedItem, preview: SharePreview(previewText))
                                .disabled(theStore.items.isEmpty)
                        })
                        ToolbarItem(placement: .principal, content: {
                            // The store list Navigation item
                            showStoreListAction
                        })
                        ToolbarItem(placement: .navigationBarTrailing, content: {
                            // The "Edit" navigation item
                            EditButton()
                            // No Edit button if there are no items
                                .disabled(StoreData.selectedStore(with: modelContext).items.count == 0)
                        })
                    }
            }
        }
        .sheet(isPresented: $isShowingStoreSheet) {
            StoresSheetView()
        }
    }
    
    var showStoreListAction: some View {
        Button() {
            isShowingStoreSheet.toggle()
        } label: {
            Text(StoreData.selectedStore(with: modelContext).name)
                .font(.title2)
        }
    }
    
    var trashCanAction: some View {
        Button() {
            showAlert = true
        } label: {
            Image(systemName: "trash")
                .accessibilityLabel("")
                .padding(.leading)
        }
        .alert("Remove all checked items?", isPresented: $showAlert) {
            Button(role: .destructive, action: {
                let store = StoreData.selectedStore(with: modelContext)
                for item in store.items {
                    if item.hasCheck {
                        if let index = store.items.firstIndex(of: item) {
                            store.items.remove(at: index)
                        }
                    }
                }
            }, label: { Text( "Delete them" )} )
            Button("Cancel", role: .cancel, action: { })
        }
        .disabled(StoreData.selectedStore(with: modelContext).items.count == 0)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: StoreData.self, configurations: config)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Can't do it")
    }
}
