//
//  ContentView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var editingItem: Bool = false
    @State private var showingStoreList: Bool = false
    @State private var showStoreList: Bool = false
    @State private var showAlert: Bool = false
    
    @FocusState var editingFocused: Bool
    
    @State private var newItemName: String = ""
    
    let alertTitle: String = NSLocalizedString("Remove?", comment: "Check whether we really want to remove items")

    var body: some View {
        VStack {
        AppHeaderView()
            NavigationView {
                VStack {
//                    EditableList<ListItem, TextField<Text>>($viewModel.selectedStore.items) { $item in
//                        TextField("Title", text: $item.name)
//                    }
                    List {
                        ForEach(viewModel.selectedStore.items, id: \..id) { item in
                            ListItemView(item: item, viewModel: viewModel)
                        }
                        .onMove { indexSet, offset in
                            viewModel.rearrangeItems(indexSet: indexSet, offset: offset)
                        }
                        .onDelete { (indexSet) in viewModel.deleteItemsByIndexSet(indexSet: indexSet)}
                        
                        if editingItem {
                            TextField("", text: $newItemName)
                                .onAppear(perform: { editingFocused = true })
                                .focused($editingFocused)
                                .onSubmit {
                                    editingItem = false
                                    if newItemName.isEmpty { return }
                                    viewModel.addItem(name: newItemName)
                                    newItemName = ""
                                }
                        } else {
                            HStack {
                                Text("+")
                                Spacer()
                            }
                            .contentShape(Rectangle())
                                .onTapGesture {
                                    editingItem = true
                                }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button() {
                        showAlert = true && viewModel.checksExistForStore(store: viewModel.selectedStore)
                    } label: {
                        Image(systemName: "trash")
                            .padding(.leading)
                    }
                    .alert(alertTitle, isPresented: $showAlert) {
                        Button(role: .destructive, action: {
                                viewModel.clearItems()
                        }, label: { Text("Delete")})
                        Button("Cancel", role: .cancel, action: { })
                    } })
                    ToolbarItem(placement: .principal, content: {
                        Button( action: {
                            showingStoreList = true
                        }, label: {
                            Text(viewModel.selectedStore.name)
                                .font(.title2)
                        })
                    })
                    ToolbarItem(placement: .navigationBarTrailing, content: { EditButton() })
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
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var viewModel: ViewModel
    
    static var previews: some View {
        ContentView()
    }
}

struct ListItemView: View {
    var item: ListItem
    var viewModel: ViewModel
    
    var body: some View {
        HStack {
            if item.hasCheck {
                Image(systemName: "checkmark")
                    .foregroundColor(.green)
                    .padding(.trailing, 8)
            }
            Text(item.name)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleCheck(item: item)
        }
    }
}
