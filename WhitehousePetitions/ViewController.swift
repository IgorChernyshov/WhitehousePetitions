//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Igor Chernyshov on 26.06.2021.
//

import UIKit

final class ViewController: UITableViewController {

	// MARK: - Properties
	private var petitions: [Petition] = []
	private var filteredPetitions: [Petition]?

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		addAboutButton()
		addSearchButton()
		loadPetitions()
	}

	// MARK: - UI Configuration
	private func addAboutButton() {
		let aboutImage = UIImage(systemName: "info.circle")
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: aboutImage, style: .plain, target: self, action: #selector(showAboutAlert))
	}

	private func addSearchButton() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchField))
	}

	// MARK: - Petitions
	private func loadPetitions() {
		let urlString = navigationController?.tabBarItem.tag == 0 ?
			"https://www.hackingwithswift.com/samples/petitions-1.json" :
			"https://www.hackingwithswift.com/samples/petitions-2.json"
		if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
			parse(json: data)
		} else {
			showError()
		}
	}

	private func parse(json: Data) {
		guard let jsonPetitions = try? JSONDecoder().decode(Petitions.self, from: json) else { return }
		petitions = jsonPetitions.results
		tableView.reloadData()
	}

	// MARK: - Errors Handling
	private func showError() {
		let alertController = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		present(alertController, animated: true)
	}

	// MARK: - Selectors
	@objc private func showAboutAlert() {
		let alertController = UIAlertController(title: "About", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default))
		present(alertController, animated: true)
	}

	@objc private func showSearchField() {
		let alertController = UIAlertController(title: "Search", message: "Enter text to search", preferredStyle: .alert)
		alertController.addTextField()
		alertController.addAction(UIAlertAction(title: "OK", style: .default) { [weak alertController, weak self] _ in
			defer { self?.tableView.reloadData() }
			guard let searchText = alertController?.textFields?.first?.text, !searchText.isEmpty else {
				self?.filteredPetitions = nil
				return
			}
			self?.filteredPetitions = self?.petitions.filter { $0.title.contains(searchText) || $0.body.contains(searchText) }
		})
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alertController, animated: true)
	}
}

// MARK: - UITableViewDataSource
extension ViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let filteredPetitions = filteredPetitions else {
			return petitions.count
		}
		return filteredPetitions.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
		let petition = filteredPetitions != nil ? filteredPetitions?[indexPath.row] : petitions[indexPath.row]
		cell.textLabel?.text = petition?.title
		cell.detailTextLabel?.text = petition?.body
		return cell
	}
}

// MARK: - UITableViewDelegate
extension ViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let viewController = DetailViewController()
		viewController.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(viewController, animated: true)
	}
}
