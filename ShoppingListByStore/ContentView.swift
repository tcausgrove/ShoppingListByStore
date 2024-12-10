//
//  ContentView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var editingItem = EditMode.inactive
    @State private var showingStoreList: Bool = false
    @State private var showStoreList: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState var editingFocused: Bool
    
    @State private var newItemName: String = ""
    
    let alertTitle: String = NSLocalizedString("Remove?", comment: "Check whether we really want to remove items")
    let alertDeleteText: String = NSLocalizedString("Delete", comment: "Delete the item(s)")
    let alertCancelText: String = NSLocalizedString("Cancel", comment: "Don't delete the item(s)")
    
    var body: some View {
        VStack {
            AppHeaderView()
            NavigationView {
                VStack {
                    Form {
                        ForEach(viewModel.selectedStore.items, id: \..id) { item in
                            ListItemView(item: item)
                                .environmentObject(viewModel)
                        }
                        .onMove { indexSet, offset in
                            viewModel.rearrangeItems(from: indexSet, to: offset)
                        }
                        .onDelete(perform: delete)

                        if editingItem == EditMode.active {
                            editingNewItemField
                        } else {
                            plusItemAtEnd
                        }
                    }
                }
                .toolbar {
                    // The delete (trashcan) navigation item
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        trashCanAction
                    })
                    // The store list Navigation item
                    ToolbarItem(placement: .principal, content: {
                        showStoreListAction
                    })
                    // The "Edit" navigation item
//                    ToolbarItem(placement: .navigationBarTrailing, content: {
//                        EditButton()
//                        // No Edit button if there are no items
//                            .disabled(viewModel.selectedStore.items.count == 0)
//                    })
                }
                .environmentObject(viewModel)
                .sheet(isPresented: $showingStoreList) {
                    StoreNameView(storeNames: viewModel.returnStoreNames,
                                  onSave: { returnedStoreNames in
                        viewModel.addStore(newStoreName:returnedStoreNames) },
                                  onChange: { newStoreName in
                        viewModel.changeSelectedStore(selectedStoreName: newStoreName)
                    } )
                }
                .environmentObject(viewModel)
            }
        }
    }

    var editingNewItemField: some View {
        TextField("", text: $newItemName)
            .onAppear(perform: { editingFocused = true })
            .focused($editingFocused)
            .onSubmit {
                if newItemName.isEmpty { return }
                viewModel.addItem(name: newItemName)
                newItemName = ""
                editingItem = EditMode.inactive
            }
    }
    
    var plusItemAtEnd: some View {
        HStack {
            Text("+")
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            editingItem = EditMode.active
        }
    }
    
    var trashCanAction: some View {
        Button() {
            showAlert = true && viewModel.checksExistForStore(store: viewModel.selectedStore)
        } label: {
            Image(systemName: "trash")
                .padding(.leading)
        }
        // Delete is diabled if there are no checkmarks
        .disabled(!viewModel.checksExistForStore(store: viewModel.selectedStore))
        // Show the "Do you really want to delete?" alert
        .alert(alertTitle, isPresented: $showAlert) {
            Button(role: .destructive, action: {
                viewModel.clearItems()
            }, label: { Text( alertDeleteText )} )
            Button(alertCancelText, role: .cancel, action: { })
        }
    }
    
    var showStoreListAction: some View {
        Button() {
            showingStoreList = true
        } label: {
            Text(viewModel.selectedStore.name)
                .font(.title2)
        }
    }
    
    func delete(source: IndexSet) {
        viewModel.deleteItemsByIndexSet(indexSet: source)
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var viewModel: ViewModel
    
    static var previews: some View {
        ContentView()
    }
}
