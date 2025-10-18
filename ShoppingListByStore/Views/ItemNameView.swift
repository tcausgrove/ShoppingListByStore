//
//  EditableTextView.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 10/11/25.
//

import SwiftUI

struct ItemNameView: View {
    var previousItem: ListItem
    
    @State private var isEditing = false
    @State private var textValue = ""

    var body: some View {
        if isEditing {
            TextField("Enter value", text: $textValue, onCommit: {
                isEditing = false
            })
            .onAppear(perform: { textValue = previousItem.name })
            .onSubmit { previousItem.name = textValue }
            .padding()
        } else {
            HStack {
                Text(previousItem.name)
                Spacer()
            }
            .contentShape(Rectangle())
            .onLongPressGesture {
                isEditing = true
            }
        }
    }
}

#Preview {
    let previewItem = ListItem(name: "Preview name", hasCheck: false)
    ItemNameView(previousItem: previewItem)
}
