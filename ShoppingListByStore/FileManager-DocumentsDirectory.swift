//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Timothy Causgrove on 11/28/22.
//

import Foundation


extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
