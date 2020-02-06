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
    var segueCity = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewWeather.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        
        let celcius :Int = Int(weatherPlaces[indexPath.row].main.temp - 273.15)
        cell.cellTemp.text = (String(celcius)+"°")
        cell.textLabel?.text = weatherPlaces[indexPath.row].name
        
       cell.weatherImage.image = UIImage(named: checkWeatherImage(int: weatherPlaces[indexPath.row].weather[0].id))
        
        return cell
    }
    
    func getWeatherForCity (city:String){
        let weatherApi = CityWeatherApi()
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
                    print(weather.timezone)
                    
                    self.weatherDescription.text = weather.weather[0].weatherDescription
                    
                    self.imageMain.image = UIImage(named: self.checkWeatherImage(int: weather.weather[0].id))
                    //Lägg till arraylistan
                    self.weatherPlaces.append(weather)
                    
                    self.tableViewWeather.reloadData()
                    }
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
   
    
    @IBAction func searchCityBtn(_ sender: Any) {
        getWeatherForCity(city: searchCityTxt.text ?? "unkown")
    }
    
    func checkWeatherImage (int: Int) -> String{
        
        switch (int) {
        
        case 200...232:
            return "thunderstorm"
        
        case 300...321:
            return "rain"
        
        case 500...531:
            return "rain"
            
        case 600...622:
            return "snow"
        
        case 701...781:
            return "fog"
        
        case 800:
            return "sun"
        
        case 801...804:
            return "suncloud"
        
        default:
            return "sun"
        
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.segueCity = (weatherPlaces[indexPath.row].name)
        self.performSegue(withIdentifier: "homeVCToDetailVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let displayVC = segue.destination as! DetailViewController
        displayVC.city = self.segueCity
    }
}
