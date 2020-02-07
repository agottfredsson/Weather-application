//
//  CompareViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-07.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var favoritePlaces = Array<String>()
    @IBOutlet weak var compareTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        compareTableView.backgroundColor = UIColor.clear
        self.compareTableView.delegate = self
        self.compareTableView.dataSource = self
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritePlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = compareTableView.dequeueReusableCell(withIdentifier: "cellCompare", for: indexPath)
        cell.textLabel?.text = favoritePlaces[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.updateData()
        
    }
    
    func updateData () {
        
    }
    


}
