//
//  StoreNameView.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 10/12/25.
//

import SwiftUI

struct StoreNameView: View {
    var previousStore: StoreData
    
    @State private var isEditing = false
    @State private var textValue = ""

    var body: some View {
        if isEditing {
            TextField("Enter value", text: $textValue, onCommit: {
                isEditing = false
            })
            .onAppear(perform: { textValue = previousStore.name })
            .onSubmit { previousStore.name = textValue }
//            .padding()
        } else {
            Text(previousStore.name)
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
