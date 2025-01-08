//
//  ErrorView.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 12/13/24.
//

import SwiftUI

struct ErrorView: View {
    let errorType: UserError
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .overlay {
                VStack {
                    Button( errorViewOK ) {
                        viewModel.userError = nil
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
    }
}

#Preview {
    ErrorView(errorType: UserError.failedSaving)
        .environmentObject(ViewModel())
}
