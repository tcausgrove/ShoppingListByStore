//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Timothy Causgrove on 11/28/22.
//

import Foundation
import SwiftUI
import Defaults

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

struct ErrorAlert: ViewModifier {
    
    @Binding var error: UserError?
    var isShowingError: Binding<Bool> {
        Binding {
            error != nil
        } set: {_ in 
            error = nil
        }
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: isShowingError, error: error) { _ in
            } message: { error in
                if let message = error.errorMessage {
                    Text(message)
                }
            }
    }
}

extension View {
    func errorAlert(_ error: Binding<UserError?>) -> some View {
        self.modifier(ErrorAlert(error: error))
    }
}


extension Defaults.Keys {
    static let selectedStoreIDKey = Key<UUID?>("selectedStoreIDKey")
}
