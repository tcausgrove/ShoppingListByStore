//
//  ListItemView.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 3/29/25.
//

import SwiftUI
import SwiftData

struct ListItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var store: StoreData

    @State private var editingItem = EditMode.inactive
    @State private var newItemName: String = ""
    @FocusState var editingFocused: Bool             // This allows editing on one tap instead of two

    var body: some View {
//        VStack {
            List {
                ForEach(store.items) { item in
                    HStack {
                        if item.hasCheck { showCheck }
                        ItemNameView(previousItem: item)
                            
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        item.toggleCheck()
                    }
                }
                .onDelete(perform: deleteItems)
                
                if editingItem == .active {
                    editingNewItemField
                } else {
                    plusItemAtEnd
                }
            }
//        }
    }
    
    var editingNewItemField: some View {
        TextField("", text: $newItemName)
            .onAppear(perform: { editingFocused = true })
            .focused($editingFocused)
            .onSubmit {
                editingItem = EditMode.inactive
                if newItemName.isEmpty { return }
                let newItem = ListItem(name: newItemName, hasCheck: false)
                StoreData.appendNewItem(to: store, with: newItem, with: modelContext)
                newItemName = ""
            }
    }
    
    var plusItemAtEnd: some View {
        Button(
            action: { editingItem = EditMode.active },
            label: { Image(systemName: "plus").foregroundColor(.blue) }
        )
    }

    var showCheck: some View {
        Image(systemName: "checkmark")
        //            .accessibilityLabel( accessibilityCheckMark )
            .foregroundColor(.green)
            .padding(.trailing, 8)
    }
    
    func deleteItems(_ indexSet: IndexSet) {
        for index in indexSet {
            store.items.remove(at: index)
        }
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
