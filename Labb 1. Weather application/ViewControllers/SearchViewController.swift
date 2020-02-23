//
//  SearchViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-06.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var cities: [String] = []
    var filteredCities: [String] = []
    var indexPathCity = ""
    
    var isSearching: Bool {
        if filteredCities.count > 0 {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCities()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    @IBAction func btnCity(_ sender: Any) {
        indexPathCity = searchController.searchBar.text ?? ""
        self.performSegue(withIdentifier: "SearchVCToHomeVC", sender: self)
        print("here:" , indexPathCity)
    }
    
    func initCities(){
        let defaults = UserDefaults.standard
        cities = defaults.stringArray(forKey: "Cities") ?? [""]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchVCToHomeVC" {
            let displayVC = segue.destination as! ViewController
            displayVC.addedCity = indexPathCity
        }
    }
}
    
extension SearchViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredCities.count
            }
            return cities.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.textLabel?.textColor = UIColor.white
        if isSearching {
            cell.textLabel?.text = filteredCities[indexPath.row]
        }   else {
            cell.textLabel?.text = cities[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if isSearching {
            indexPathCity = filteredCities[indexPath.row]
            print(indexPathCity)
        } else {
            indexPathCity = cities[indexPath.row]
            print(indexPathCity)
        }
        
        self.performSegue(withIdentifier: "SearchVCToHomeVC", sender: self)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchText = searchController.searchBar.text ?? ""
        filteredCities = cities.filter({ $0.lowercased().contains(searchText.lowercased()) } )
        searchTableView.reloadData()
    }
}


