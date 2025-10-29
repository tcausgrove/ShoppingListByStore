//
//  AppHeaderView.swift
//  StoreWiseShoppingList
//
//  Created by Timothy Causgrove on 5/27/25.
//

import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        Text( "StoreWiseShoppingList" )
            .font(.title)
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 50,
                   maxHeight: 50,
                   alignment: .center)
            .background(Color(.myAccent))
    }
}

#Preview {
    AppHeaderView()
}
