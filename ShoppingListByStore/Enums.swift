//
//  Enums.swift
//  ShoppingListByStore
//
//  Created by Timothy Causgrove on 12/11/24.
//

import Foundation


enum UserError: LocalizedError {
    case failedLoading
    case failedSaving
    
    var errorDescription: String? {    // This shows up as the first thing in bold in the error alert
        switch self {
        case .failedLoading:
            return NSLocalizedString("data_error", comment: "General file error message")
        case .failedSaving:
            return NSLocalizedString("data_error", comment: "General file error message")
        }
    }
    
    var errorMessage: String? {    // This shows up as the second thing in smaller text in the error alert
        switch self {
        case .failedLoading: NSLocalizedString("failed_loading", comment: "The error message when loading data doesn't work")
        case .failedSaving: NSLocalizedString("failed_saving", comment: "The error message when saving data doesn't work")
        }
    }
}
