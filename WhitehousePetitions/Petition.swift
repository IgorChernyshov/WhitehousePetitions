//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Igor Chernyshov on 27.06.2021.
//

import Foundation

struct Petitions: Codable {
	var results: [Petition]
}
struct Petition: Codable {
	var title: String
	var body: String
	var signatureCount: Int
}
