//
//  ViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-05.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var txtTip: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var tableViewWeather: UITableView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var imageMain: UIImageView!
    
    var weatherPlaces = Array<Weather>()
    var favoritePlaces = Array<String>()
    var segueCity = ""
    var homescreen :String = ""
    var addedCity = ""
    
    var isFav: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadState()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        tableViewWeather.backgroundColor = UIColor.clear
        
        self.tableViewWeather.delegate = self
        self.tableViewWeather.dataSource = self
    }
    
   
   

    override func viewWillAppear(_ animated: Bool) {
        
        
        getWeatherForCity(city: self.homescreen)
        addCityToArray(city: addedCity)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherPlaces.count
    }
    
    func weatherTip (temp :Int){
        switch temp {
        case ..<0 : txtTip.text = "Tip: Grab tons of clothes!"
            
        case 0...10: txtTip.text = "Tip: You're ok with a jacket! "
            
        case 11...20: txtTip.text = "Tip: You'll be fine with a hoodie!"
            
        case 20... : txtTip.text = "Tip: Just get a T-shirt, its enough!"
            
        default:
            txtTip.text = "nononono"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewWeather.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        cell.textLabel?.textColor = UIColor.white
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
                    
                    
                    let celcius :Int = Int(weather.main.temp - 273.15)
                    self.cityName.text = weather.name
                    self.cityTemp.text = String(celcius)+"°"
                    self.weatherDescription.text = weather.weather[0].weatherDescription.capitalized
                    
                    self.weatherTip(temp: celcius)
                    
                    self.imageMain.image = UIImage(named: weatherString.checkWeatherImage(int: weather.weather[0].id))
                    
                    self.txtTime.text = self.convertTimeZoneClock(timezone: weather.timezone)
                    
                    self.tableViewWeather.reloadData()
                    self.saveState()
                    }
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.segueCity = (self.weatherPlaces[indexPath.row].name)
        self.performSegue(withIdentifier: "homeVCToDetailVC", sender: self)
        
    }
   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeVCToDetailVC" {
        let displayVC = segue.destination as! DetailViewController
        displayVC.city = self.segueCity
        displayVC.isCityFav = self.homescreen
        displayVC.favoritePlaces = self.favoritePlaces
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
    
    func convertTimeZoneClock (timezone: Int) -> String {
           let time = NSDate().timeIntervalSince1970
           let x :Int = Int(time)
           
           let date = NSDate(timeIntervalSince1970: TimeInterval(x))
           let dateFormatter = DateFormatter()
           dateFormatter.timeStyle = DateFormatter.Style.short
           dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
           
           let localdate = dateFormatter.string(from: date as Date)
           
           return localdate
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
                    addCityToArray(city: string as! String)
                    tableViewWeather.reloadData()
            }
        }
        
        self.getWeatherForCity(city: defaults.string(forKey: "favorite") ?? "sweden")
        
        if defaults.array(forKey: "Cities") == nil {
            self.initCities()
        }
    }
    
    func initCities (){
        let initCities = initCitiesArray()
        let defaults = UserDefaults.standard
        defaults.set(initCities.initCities(), forKey: "Cities")
    }
   
    
}
