//
//  AppHeaderView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 3/11/23.
//

import SwiftUI


struct AppHeaderView: View {
    var body: some View {
        ZStack {
            Text(NSLocalizedString("App name", comment: "The overall app name"))
                .font(.title)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                .foregroundColor(.black)
                .background(.teal)
        }
    }
}

struct AppHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AppHeaderView()
    }
}
