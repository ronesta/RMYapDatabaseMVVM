//
//  CharacterCellViewModel.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 30.01.2025.
//

import Foundation
import UIKit

struct CharacterCellViewModel: CharacterCellViewModelProtocol {
    var image: UIImage?
    let name: String
    let speciesAndGender: String
    let buttonTitle: String
    let markerImage: UIImage?
    let location: String
    let status: String
    var statusBackgroundColor: UIColor
    var statusTextColor: UIColor

    init(character: Character, image: UIImage?) {
        self.image = image
        self.name = character.name
        self.speciesAndGender = "\(character.species), \(character.gender)"
        self.buttonTitle = "▶ Watch episodes"
        self.markerImage = UIImage(named: "marker")
        self.location = character.location.name
        self.status = character.status
        self.statusBackgroundColor = UIColor()
        self.statusTextColor = UIColor()

        switch character.status {
        case "Dead":
            let filteredImage = self.applyBlackAndWhiteFilter(to: image ?? UIImage())
            self.image = filteredImage
            self.statusBackgroundColor = .red.withAlphaComponent(0.1)
            self.statusTextColor = .systemRed
        case "unknown":
            self.statusBackgroundColor = .gray.withAlphaComponent(0.1)
            self.statusTextColor = .systemGray
        default:
            self.statusBackgroundColor = .green.withAlphaComponent(0.2)
            self.statusTextColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        }
    }

    private func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage? {
        guard let currentCIImage = CIImage(image: image) else {
            return nil
        }

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")

        guard let outputImage = filter?.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
