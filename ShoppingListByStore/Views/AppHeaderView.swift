//
//  AppHeaderView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 3/11/23.
//

import SwiftUI


struct AppHeaderView: View {
    var body: some View {
        Text( headerAppName )
            .font(.title)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)
            .background(Color(.myAccent))
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppHeaderView()
    }
}
