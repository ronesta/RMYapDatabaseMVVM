//
//  StorageManagerProtocol.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 30.01.2025.
//

import Foundation

protocol StorageManagerProtocol {
    func saveCharacter(_ character: Character, key: String)

    func saveCharacters(_ characters: [Character])

    func loadCharacter(key: String) -> Character?

    func loadCharacters() -> [Character]

    func clearCharacters()

    func saveImage(_ image: Data, key: String)

    func loadImage(key: String) -> Data?

    func clearImage(key: String)
}
