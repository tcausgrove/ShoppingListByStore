//
//  StoreNameView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 2/13/23.
//

import SwiftUI

struct StoreNameView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ViewModel
    
    var storeNames: [String]
    var onSave: (String) -> Void
    var onChange: (String) -> Void
    
    @State private var addingStore: Bool = false
    @State private var newStoreName = ""
    @FocusState var editingFocused: Bool
    
    var body: some View {
        VStack {
            Text(NSLocalizedString("Listtitle", comment: "Appears above the list of store names"))
                .font(.title2)
            List {
                ForEach(storeNames, id: \.self) { storeName in
                    HStack {
                        Text(storeName)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onChange(storeName)
                        dismiss()
                    }
//                    .onLongPressGesture {
                        // rename store
//                    }
                }
//                .onMove { indexSet, offset in storeNames.move(fromOffsets: indexSet, toOffset: offset)}
                .onDelete { (indexSet) in viewModel.deleteStores(indexSet: indexSet) }
                
                if addingStore {
                    TextField("", text: $newStoreName)
                        .onAppear(perform: { editingFocused = true })
                        .focused($editingFocused)
                        .onSubmit {
                            addingStore = false
                            if !newStoreName.isEmpty { 
                            onSave(newStoreName)
                            newStoreName = ""
                            dismiss()
                            }
                        }
                } else {
                    Text("+")
                        .onTapGesture {
                            addingStore = true
                        }
                }
            }
        }
        .toolbar { EditButton() }
    }
    
    init(storeNames: [String], onSave: @escaping (String) -> Void, onChange: @escaping (String) -> Void ) {
        self.storeNames = storeNames
        self.onSave = onSave
        self.onChange = onChange
        
//        _storeNameViewModel = StateObject(wrappedValue: StoreNameViewModel())
    }
}

struct StoreNameView_Previews: PreviewProvider {
    static var previews: some View {
        StoreNameView(storeNames: ["Preview 1", "Preview 2"], onSave: { _ in }, onChange: { _ in })
    }
}
