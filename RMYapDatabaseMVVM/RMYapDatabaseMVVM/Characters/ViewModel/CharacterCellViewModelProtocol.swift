//
//  CharacterCellViewModelProtocol.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 30.01.2025.
//

import Foundation
import UIKit

protocol CharacterCellViewModelProtocol {
    var image: UIImage? { get set }
    var name: String { get }
    var speciesAndGender: String { get }
    var buttonTitle: String { get }
    var markerImage: UIImage? { get }
    var location: String { get }
    var status: String { get }
    var statusBackgroundColor: UIColor { get set }
    var statusTextColor: UIColor { get set }

    init(character: Character, image: UIImage?)
}
