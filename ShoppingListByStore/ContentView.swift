//
//  ContentView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State private var showingStoreList: Bool = false
    @State private var showStoreList: Bool = false
    @State private var showAlert: Bool = false
   
    var body: some View {
        VStack {
            AppHeaderView()
            NavigationView {
                VStack {
                    ItemListView()
                        .errorAlert($viewModel.userError)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        // The delete (trashcan) navigation item
                        trashCanAction
                    })
                    ToolbarItem(placement: .principal, content: {
                        // The store list Navigation item
                        showStoreListAction
                    })
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        // The "Edit" navigation item
                        EditButton()
                        // No Edit button if there are no items
                            .disabled(viewModel.selectedStore.items.count == 0)
                    })
                }
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
        .background(Color(.myAccent))
    }
    
    var trashCanAction: some View {
        Button() {
            showAlert = viewModel.checksExistForStore(store: viewModel.selectedStore)
        } label: {
            Image(systemName: "trash")
                .accessibilityLabel(viewModel.checksExistForStore(store: viewModel.selectedStore) ? accessibilityDeleteLabel : "")
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
                .accessibilityLabel( accessibilityStoreList )
                .accessibilityValue(viewModel.selectedStore.name)
                .font(.title2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var viewModel: ViewModel
    
    static var previews: some View {
        ContentView()
    }
}
