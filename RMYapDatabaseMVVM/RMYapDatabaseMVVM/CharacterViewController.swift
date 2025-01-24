//
//  ViewController.swift
//  RMYapDatabaseMVVM
//
//  Created by Ибрагим Габибли on 24.01.2025.
//

import UIKit
import SnapKit

final class CharacterViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        return tableView
    }()

    var characters = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        getCharacters()
    }

    private func setupNavigationBar() {
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self,
                           forCellReuseIdentifier: CharacterTableViewCell.id)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func getCharacters() {
        let savedCharacters = DatabaseManager.shared.loadAllCharacters()
        if !savedCharacters.isEmpty {
            self.characters = savedCharacters
            self.tableView.reloadData()
        } else {
            NetworkManager.shared.getCharacters { [weak self] result in
                switch result {
                case .success(let characters):
                    DispatchQueue.main.async {
                        self?.characters = characters
                        self?.tableView.reloadData()
                        characters.forEach { character in
                            DatabaseManager.shared.saveCharacter(character, key: "\(character.id)")
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch characters: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension CharacterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterTableViewCell.id,
            for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }

        let character = characters[indexPath.row]
        let imageURL = character.image

        NetworkManager.shared.loadImage(from: imageURL) { loadedImage in
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? CharacterTableViewCell  else {
                    return
                }
                cell.configure(with: character, image: loadedImage)
            }
        }

        return cell
    }
}

extension CharacterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        128
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
