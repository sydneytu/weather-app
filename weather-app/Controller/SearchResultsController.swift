//
//  SearchResultsController.swift
//  weather-app
//
//  Created by Sydney Turner on 8/10/22.
//

import UIKit

private let reuseIdentifier = "CityCell"

protocol SearchWeatherDelegate: AnyObject {
    func searchDidComplete(with place: SearchResultsModel)
}

class SearchResultsController: UITableViewController {
    var results = [SearchResultsModel]()
    var weatherManager = WeatherManager()
    var delegate: SearchWeatherDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        configureTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Helpers
    func configureTableView() {
        view.backgroundColor = .white
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(CityCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 56
    }
    
    func configureSearchController() {
        tableView.tableHeaderView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func showNoResultslabel() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = "No Results Found."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        tableView.backgroundView = label
        tableView.separatorStyle = .none
    }
}

// MARK: - UITableViewDataSource
extension SearchResultsController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let textInput = searchController.searchBar.text {
            if searchController.isActive && textInput.count > 2 {
                if results.count == 0 {
                    showNoResultslabel()
                    return 0
                }
            }
        }
        tableView.separatorStyle = .singleLine
        tableView.backgroundView = nil
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CityCell
        cell.city = results[indexPath.row]
        return cell
    }
}

extension SearchResultsController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = self.results[indexPath.row]
        dismiss(animated: true) {
            self.searchController.searchBar.text = ""
            self.results = []
            self.delegate?.searchDidComplete(with: place)
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchResultsController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: make it so when clicked it shows the results
        print("DEBUG: Search clicked")
    }
}

extension SearchResultsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            weatherManager.fetchSearches(input: text) { searchResults in
                DispatchQueue.main.async {
                    self.results = searchResults
                    self.tableView.reloadData()
                }
            }
        }
        else {
            self.results = []
            self.tableView.reloadData()
        }
    }
}
