//
//  SwiftUIView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 12/13/24.
//

import SwiftUI

struct ItemListView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var editingItem = EditMode.inactive
    @State private var newItemName: String = ""
    @FocusState var editingFocused: Bool
    
    var body: some View {
        List {
            ForEach(viewModel.selectedStore.items) { item in
                HStack {
                    if item.hasCheck { showCheck }
                    Text(item.name)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture { viewModel.toggleCheck(item: item) }
            }
            .onMove { indexSet, offset in viewModel.rearrangeItems(from: indexSet, to: offset) }
            .onDelete(perform: delete)
            
            if editingItem == EditMode.active {
                editingNewItemField
            } else {
                plusItemAtEnd
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
    
    var showCheck: some View {
        Image(systemName: "checkmark")
            .foregroundColor(.green)
            .padding(.trailing, 8)
    }
    
    func delete(source: IndexSet) {
        viewModel.deleteItemsByIndexSet(indexSet: source)
    }
}

#Preview {
    ItemListView()
        .environmentObject(ViewModel())
}