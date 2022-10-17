//
//  SearchResultsController.swift
//  weather-app
//
//  Created by Sydney Turner on 8/10/22.
//

import UIKit

class SearchResultsController: UITableViewController {
    
    
//    private let searchTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Enter location"
//        tf.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
//        tf.layer.cornerRadius = 5
//        return tf
//    }()
//
//    private let searchButton: UIButton = {
//        let bt = UIButton()
//        bt.setTitle("Done", for: .normal)
//        bt.titleLabel?.textColor = .blue
//        bt.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
//        return bt
//    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchTextField.delegate = self
        
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9138072133, green: 0.9178827405, blue: 0.9283933043, alpha: 1)
//        let stackView = UIStackView(arrangedSubviews: [searchTextField, searchButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillProportionally
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
//        ])
//
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITextFieldDelegate
//extension SearchResultsController: UITextFieldDelegate {
//    @objc func doneButtonPressed() {
//        searchTextField.endEditing(true)
//        dismiss(animated: true)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchTextField.endEditing(true)
//        print(searchTextField.text!)
//        return true
//    }
//    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            searchButton.setTitle("Cancel", for: .normal)
//            return true
//        }
//        else {
//            textField.placeholder = "Enter location"
//            return false
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let city = searchTextField.text {
////            weatherManager.fetchForecastWeather(cityName: city)
//            // TODO: pass city name back to weatherVC to make fetch call
//        }
//        searchTextField.text = ""
//    }
//    
//}
