//
//  Enums.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 12/11/24.
//

import Foundation


enum UserError: Error {
    case failedLoading
    case failedSaving
    
    var description: String {
        switch self {
        case .failedLoading:
            return NSLocalizedString("Failed loading", comment: "The error message when loading data doesn't work")
        case .failedSaving:
            return NSLocalizedString("FailedSaving", comment: "The error message when saving data doesn't work")
        }
    }
}
