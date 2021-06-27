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

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		let urlString = navigationController?.tabBarItem.tag == 0 ?
			"https://www.hackingwithswift.com/samples/petitions-1.json" :
			"https://www.hackingwithswift.com/samples/petitions-2.json"
		if let url = URL(string: urlString), let data = try? Data(contentsOf: url) {
			parse(json: data)
		} else {
			showError()
		}
	}

	// MARK: - Data Parsing
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
}

// MARK: - UITableViewDataSource
extension ViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		petitions.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Petition", for: indexPath)
		let petition = petitions[indexPath.row]
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
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
