//
//  SearchResultsController.swift
//  weather-app
//
//  Created by Sydney Turner on 8/10/22.
//

import UIKit

class SearchResultsController: UITableViewController {
    var results = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureUI()
        
        tableView.register(CityCell.self, forCellReuseIdentifier: "CityCell")
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helpers
}

// MARK: - UITableViewDataSource
extension SearchResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
//        content.text = results[indexPath.row]
        cell.contentConfiguration = content
        return cell
        
    }
}
