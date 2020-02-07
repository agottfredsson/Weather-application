//
//  CompareViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-07.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var txtHumidityCurrent: UILabel!
    
    @IBOutlet weak var txtWindCurrent: UILabel!
    
    @IBOutlet weak var txtHumidityCompared: UILabel!
    
    @IBOutlet weak var txtWindCompared: UILabel!
    
    
    @IBOutlet weak var txtTempCompared: UILabel!
    @IBOutlet weak var txtTempCurrent: UILabel!
    @IBOutlet weak var currentTemp: UIView!
    @IBOutlet weak var txtCompareCity: UILabel!
    @IBOutlet weak var txtCurrentCity: UILabel!
    var favoritePlaces = Array<String>()
    @IBOutlet weak var compareTableView: UITableView!
    
    var CurrentCity = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        compareTableView.backgroundColor = UIColor.clear
        txtCurrentCity.text = self.CurrentCity
        self.compareTableView.delegate = self
        self.compareTableView.dataSource = self
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWeatherForCurrentCity(city: CurrentCity)
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
        
        self.updateData(index: indexPath.row)
        self.getWeatherForCompareCity(city: favoritePlaces[indexPath.row])
        
    }
    
    func updateData (index: Int) {
        self.txtCompareCity.text = favoritePlaces[index]
        
        
        
        
        
        
        
    }
    
    func getWeatherForCurrentCity (city:String){
        let weatherApi = CityWeatherApi()
        weatherApi.getWeatherForCity(city:city) { (result) in
        switch result {
            case .success(let weather):
                
                DispatchQueue.main.async {
                   // let celcius :Int = Int(weather.main.temp - 273.15)
                    
                    //self.heightConstraint.constant = CGFloat(celcius * 5)
        
                    self.txtTempCurrent.text = String(Int(weather.main.temp - 273.15)) + "°C"
                    self.txtHumidityCurrent.text = String(Int(weather.main.humidity)) + "%"
                    self.txtWindCurrent.text = String(Int(weather.wind.speed)) + "m/s"
                    }
            
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
    
    
    
    
    
    func getWeatherForCompareCity (city:String){
        let weatherApi = CityWeatherApi()
        weatherApi.getWeatherForCity(city:city) { (result) in
        switch result {
            case .success(let weather):
                
                DispatchQueue.main.async {
                    self.txtTempCompared.text = String(Int(weather.main.temp - 273.15)) + "°C"
                    self.txtHumidityCompared.text = String(Int(weather.main.humidity)) + "%"
                    self.txtWindCompared.text = String(Int(weather.wind.speed)) + "m/s"
                    
                    }
            
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
    


}
