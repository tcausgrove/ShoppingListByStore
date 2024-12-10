//
//  ListItemView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 12/7/24.
//

import SwiftUI

struct ListItemView: View {
    var item: ListItem
    @EnvironmentObject var viewModel: ViewModel
    
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

#Preview {
    ListItemView(item: ListItem.example)
        .environmentObject(ViewModel())
}
