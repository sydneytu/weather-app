//
//  SearchModel.swift
//  weather-app
//
//  Created by Sydney Turner on 11/5/22.
//

import Foundation

struct SearchResultsModel {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
}

typealias SearchModel = [SearchResultsModel]
