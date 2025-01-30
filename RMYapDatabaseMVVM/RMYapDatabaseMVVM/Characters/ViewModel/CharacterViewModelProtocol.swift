//
//  CharacterViewModelProtocol.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 30.01.2025.
//

import Foundation

protocol CharacterViewModelProtocol {
    var characters: Observable<[Character]> { get set }

    func getCharacters()
    func numberOfCharacters() -> Int
    func character(at index: Int) -> Character
}
