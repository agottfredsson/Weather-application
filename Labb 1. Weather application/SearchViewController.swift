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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        
    }
    
    @IBAction func btnCityEntered(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchVCToHomeVC" {
            let displayVC = segue.destination as! ViewController
            displayVC.addedCity = self.txtCity.text ?? ""
        }
    }

}
