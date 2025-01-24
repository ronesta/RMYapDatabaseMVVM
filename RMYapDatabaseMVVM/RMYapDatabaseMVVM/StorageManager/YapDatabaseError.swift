//
//  YapDatabaseError.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 24.01.2025.
//

import Foundation

enum YapDatabaseError: Error {
    case databaseInitializationFailed
    case encodingFailed(Error)
    case decodingFailed(Error)
}
