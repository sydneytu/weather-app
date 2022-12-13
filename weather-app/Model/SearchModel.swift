//
//  SearchModel.swift
//  weather-app
//
//  Created by Sydney Turner on 11/5/22.
//

import Foundation

struct SearchModel {
    let searchResults: [SearchResultsModel]
}

struct SearchResultsModel {
    let name: String
    let region: String
    let lat: Double
    let lon: Double
}
