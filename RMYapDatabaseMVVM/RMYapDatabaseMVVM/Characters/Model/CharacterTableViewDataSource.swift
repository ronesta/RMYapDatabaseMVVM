//
//  CharacterTableViewDataSource.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 30.01.2025.
//

import Foundation
import UIKit

final class CharacterTableViewDataSource: NSObject, CharacterDataSourceProtocol {
    var viewModel: CharacterViewModelProtocol?
    var networkManager: NetworkManagerProtocol?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfCharacters() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterTableViewCell.id,
            for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        guard let character = viewModel?.character(at: indexPath.row) else {
            return UITableViewCell()
        }

        let imageURL = character.image

        networkManager?.loadImage(from: imageURL) { loadedImage in
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell  else {
                    return
                }

                let viewModel = CharacterCellViewModel(character: character, image: loadedImage)
                cell.configure(with: viewModel)
            }
        }

        return cell
    }
}
