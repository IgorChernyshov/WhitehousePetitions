//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by Igor Chernyshov on 27.06.2021.
//

import UIKit
import WebKit

final class DetailViewController: UIViewController {

	private let webView = WKWebView()
	var detailItem: Petition?

	override func loadView() {
		view = webView
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		guard let detailItem = detailItem else { return }

		let html = """
		<html>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style> body { font-size: 150%; } </style>
		</head>
		<body>
		\(detailItem.body)
		</body>
		</html>
		"""
		webView.loadHTMLString(html, baseURL: nil)
    }
}
