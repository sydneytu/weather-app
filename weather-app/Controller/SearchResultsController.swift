//
//  SearchResultsController.swift
//  weather-app
//
//  Created by Sydney Turner on 8/10/22.
//

import UIKit

private let reuseIdentifier = "CityCell"

class SearchResultsController: UITableViewController {
    var results = [SearchResultsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 56
    }
    
    // MARK: - Helpers
}

// MARK: - UITableViewDataSource
extension SearchResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        cell.city = results[indexPath.row]
        return cell
    }
}
