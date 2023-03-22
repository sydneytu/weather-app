//
//  SearchResultsController.swift
//  weather-app
//
//  Created by Sydney Turner on 8/10/22.
//

import UIKit

private let reuseIdentifier = "CityCell"

class SearchResultsController: UITableViewController {
    var results = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
//        configureUI()
        
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 56
    }
    
    // MARK: - Helpers
}

// MARK: - UITableViewDataSource
extension SearchResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
//        var content = cell.defaultContentConfiguration()
//        content.text = results[indexPath.row]
//        cell.contentConfiguration = content
//        cell.backgroundColor = .systemBlue
        return cell
        

    }
}
