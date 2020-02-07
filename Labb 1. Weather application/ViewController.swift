//
//  ViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-05.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var tableViewWeather: UITableView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var searchCityTxt: UITextField!
    @IBOutlet weak var imageMain: UIImageView!
    
    var weatherPlaces = Array<Weather>()
    var favoritePlaces = Array<String>()
    var segueCity = ""
    var homescreen :String = ""
    var addedCity = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadState()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        tableViewWeather.backgroundColor = UIColor.clear
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView =  false
        view.addGestureRecognizer(tap)
        
        self.tableViewWeather.delegate = self
        self.tableViewWeather.dataSource = self
}

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        getWeatherForCity(city: self.homescreen)
        addCityToArray(city: addedCity)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewWeather.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        let weatherString = WeatherString()
        let celcius :Int = Int(weatherPlaces[indexPath.row].main.temp - 273.15)
        cell.cellTemp.text = (String(celcius)+"°")
        cell.textLabel?.text = weatherPlaces[indexPath.row].name
        
        cell.weatherImage.image = UIImage(named: weatherString.checkWeatherImage(int: weatherPlaces[indexPath.row].weather[0].id))
        
        return cell
    }
    
    func getWeatherForCity (city:String){
        let weatherApi = CityWeatherApi()
        let weatherString = WeatherString()
        weatherApi.getWeatherForCity(city:city) { (result) in
        switch result {
            case .success(let weather):
                
                DispatchQueue.main.async {
                    //Uppdatera UI
                    let celcius :Int = Int(weather.main.temp - 273.15)
                    let celciusMax :Int = Int(weather.main.tempMax - 273.15)
                    let celciusMin :Int = Int(weather.main.tempMin - 273.15)
                    
                    self.cityName.text = weather.name
                    self.cityTemp.text = String(celcius)+"°"
                    self.maxTemp.text = String(celciusMax)+"°C"
                    self.minTemp.text = String(celciusMin)+"°C"
                    
                    self.weatherDescription.text = weather.weather[0].weatherDescription
                    
                    self.imageMain.image = UIImage(named: weatherString.checkWeatherImage(int: weather.weather[0].id))
                    
                    
                    //Lägg till arraylistan
              //      self.weatherPlaces.append(weather)
                    self.tableViewWeather.reloadData()
                    self.saveState()
                    }
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.segueCity = (weatherPlaces[indexPath.row].name)
        self.performSegue(withIdentifier: "homeVCToDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeVCToDetailVC" {
        let displayVC = segue.destination as! DetailViewController
        displayVC.city = self.segueCity
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            weatherPlaces.remove(at: indexPath.row)
            self.saveState()
            tableViewWeather.reloadData()
        }
    }
    
    func addCityToArray (city:String){
        let weatherApi = CityWeatherApi()
        weatherApi.getWeatherForCity(city:city) { (result) in
        switch result {
            case .success(let weather):
                    DispatchQueue.main.async {
                    self.weatherPlaces.append(weather)
                    self.tableViewWeather.reloadData()
                    self.saveState()
            }
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
    
    
    func saveState() {
        let defaults = UserDefaults.standard
        favoritePlaces.removeAll()
        for x in weatherPlaces {
            favoritePlaces.append(x.name)
        }
       
        defaults.set(favoritePlaces, forKey:"places")
        
        if self.homescreen != "" {
            defaults.set(self.homescreen, forKey: "favorite")
        }
    }
    
    func loadState() {
        
        let defaults = UserDefaults.standard
        
        if defaults.array(forKey: "places") != nil {
            let favoritePlaces:Array = defaults.array(forKey: "places")!
                for string in favoritePlaces {
                    //getWeatherForCity(city: string as! String)
                    addCityToArray(city: string as! String)
                    tableViewWeather.reloadData()
                    }
            }
        self.getWeatherForCity(city: defaults.string(forKey: "favorite") ?? "")
        
    }
    
}
