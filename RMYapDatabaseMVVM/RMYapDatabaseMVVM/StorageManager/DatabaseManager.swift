//
//  DatabaseManager.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 24.01.2025.
//

import Foundation
import UIKit
import YapDatabase

final class DatabaseManager: StorageManagerProtocol {
    private let charactersKey = "charactersKey"
    private let charactersCollection = "characters"
    private let imagesCollection = "images"
    private let charactersOrderCollection = "charactersOrder"
    private let database: YapDatabase
    private let connection: YapDatabaseConnection

    init() {
        do {
            database = try DatabaseManager.setupDatabase()
            database.registerCodableSerialization(Character.self, forCollection: charactersCollection)
            connection = database.newConnection()
        } catch {
            fatalError("Failed to initialize YapDatabase with error: \(error)")
        }
    }

    private static func setupDatabase() throws -> YapDatabase {
        guard let baseDir = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask).first else {
            throw YapDatabaseError.databaseInitializationFailed
        }

        let databasePath = baseDir.appendingPathComponent("database.sqlite")

        guard let database = YapDatabase(url: databasePath) else {
            throw YapDatabaseError.databaseInitializationFailed
        }

        return database
    }

    func saveCharacter(_ character: Character, key: String) {
        connection.readWrite { transaction in
            transaction.setObject(character, forKey: key, inCollection: charactersCollection)

            var order = transaction.object(
                forKey: "order",
                inCollection: charactersOrderCollection) as? [String] ?? []

            if !order.contains(key) {
                order.append(key)
                transaction.setObject(order, forKey: "order", inCollection: charactersOrderCollection)
            }
        }
    }

    func saveCharacters(_ characters: [Character]) {
        do {
            let data = try JSONEncoder().encode(characters)
            connection.readWrite { transaction in
                transaction.setObject(data, forKey: charactersKey, inCollection: charactersCollection)
            }
        } catch {
            print("Failed to encode characters: \(error)")
        }
    }

    func loadCharacter(key: String) -> Character? {
        var character: Character?

        connection.read { transaction in
            character = transaction.object(forKey: key, inCollection: charactersCollection) as? Character
        }
        return character
    }

    func loadCharacters() -> [Character] {
        var characters = [Character]()

        connection.read { transaction in
            if let order = transaction.object(forKey: "order", inCollection: charactersOrderCollection) as? [String] {
                for key in order {
                    if let character = transaction.object(
                        forKey: key,
                        inCollection: charactersCollection) as? Character {
                        characters.append(character)
                    }
                }
            }
        }

        return characters
    }

    func saveImage(_ image: Data, key: String) {
        connection.readWrite { transaction in
            transaction.setObject(image, forKey: key, inCollection: imagesCollection)
        }
    }

    func loadImage(key: String) -> Data? {
        var result: Data?

        connection.read { transaction in
            if let data = transaction.object(forKey: key, inCollection: imagesCollection) as? Data {
                result = data
            } else {
                result = nil
            }
        }
        return result
    }
}

// MARK: extension DatabaseManager
extension DatabaseManager {
    func clearCharacter(key: String) {
        connection.readWrite { transaction in
            transaction.removeObject(forKey: key, inCollection: charactersCollection)
        }
    }

    func clearCharacters() {
        connection.readWrite { transaction in
            transaction.removeAllObjects(inCollection: charactersCollection)
        }
    }

    func clearImage(key: String) {
        connection.readWrite { transaction in
            transaction.removeObject(forKey: key, inCollection: imagesCollection)
        }
    }
}
