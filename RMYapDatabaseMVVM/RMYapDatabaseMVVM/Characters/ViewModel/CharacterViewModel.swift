//
//  CharacterViewModel.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 30.01.2025.
//

import Foundation

final class CharacterViewModel: CharacterViewModelProtocol {
    var characters: Observable<[Character]> = Observable([])
    private let networkManager: NetworkManagerProtocol
    private let storageManager: StorageManagerProtocol

    init(networkManager: NetworkManagerProtocol,
         storageManager: StorageManagerProtocol
    ) {
        self.networkManager = networkManager
        self.storageManager = storageManager
    }

    func getCharacters() {
        let savedCharacters = storageManager.loadCharacters()

        if !savedCharacters.isEmpty {
            characters.value = savedCharacters
        } else {
            networkManager.getCharacters { [weak self] result in
                switch result {
                case .success(let characters):
                    DispatchQueue.main.async {
                        self?.characters.value = characters
                        characters.forEach { character in
                            self?.storageManager.saveCharacter(character, key: "\(character.id)")
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch characters: \(error.localizedDescription)")
                }
            }
        }
    }

    func numberOfCharacters() -> Int {
        return characters.value.count
    }

    func character(at index: Int) -> Character {
        return characters.value[index]
    }
}
