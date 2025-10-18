//
//  StoreNameView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/13/23.
//

import SwiftUI

struct LegacyStoreNameView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var storeNames: [String]
    var onSave: (String) -> Void
    var onChange: (String) -> Void
    
    @State private var addingStore: Bool = false
    @State private var newStoreName = ""
    @FocusState var editingFocused: Bool
    @State private var editingStoreName: String? = nil
    @State private var editingItem = EditMode.inactive
    
    var body: some View {
        NavigationView {
            VStack {
                Text( "List of stores" )
                    .font(.title2)
                List {
                    ForEach(storeNames, id: \.self) { storeName in
                        HStack {
                            if (editingStoreName == storeName) {
                                TextField(storeName, text: $newStoreName)
                                    .accessibilityLabel( "Enter new store name" )
                                    .onAppear(perform: { editingFocused = true })
                                    .focused($editingFocused)
                                    .onSubmit {
                                        editingStoreName = nil
                                        if !newStoreName.isEmpty {
                                            viewModel.renameStore(oldStoreName: storeName, newStoreName: newStoreName)
                                        }
                                        dismiss()
                                    }
                            } else {
                                Text(storeName)
                            }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            onChange(storeName)
                            dismiss()
                        }
                        .swipeActions(edge: .leading) {
                            Button (action: { editingStoreName = storeName }) {
                                Text("Rename")
                            }
                            .tint(.blue)
                        }
                    }
                    .onMove { indexSet, offset in
                        viewModel.rearrangeStores(from: indexSet, to: offset)}
                    .onDelete { (indexSet) in
                        withAnimation {
                            viewModel.deleteStores(indexSet: indexSet) }
                    }
                    
                    if addingStore {
                        addingStoreView
                    } else {
                        Button(
                            action: { addingStore = true },
                            label: { Image(systemName: "plus").foregroundColor(.blue) }
                        )
                        .accessibilityLabel( "New store" )
                        .accessibilityHint( "Enter the name for a new store" )
                    }
                }
            }
        }
    }
    
    init(storeNames: [String], onSave: @escaping (String) -> Void, onChange: @escaping (String) -> Void ) {
        self.storeNames = storeNames
        self.onSave = onSave
        self.onChange = onChange
    }
    
    var addingStoreView: some View {
        TextField("", text: $newStoreName)
            .onAppear(perform: { editingFocused = true })
            .focused($editingFocused)
            .onSubmit {
                addingStore = false
                checkForEmptyName()
            }
    }
    
    func checkForEmptyName() {
        if !newStoreName.isEmpty {
            onSave(newStoreName)
            newStoreName = ""
            dismiss()
        }
    }
}

struct StoreNameView_Previews: PreviewProvider {
    static var previews: some View {
        LegacyStoreNameView(storeNames: ["Preview 1", "Preview 2"], onSave: { _ in }, onChange: { _ in })
            .environmentObject(ViewModel())
    }
}
