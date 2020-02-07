//
//  DetailViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-06.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailCity: UILabel!
    @IBOutlet weak var detailMaxTemp: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailMinTemp: UILabel!
    @IBOutlet weak var detailTemp: UILabel!
    @IBOutlet weak var detailDesc: UILabel!
    @IBOutlet weak var txtSunrise: UILabel!
    @IBOutlet weak var txtSunset: UILabel!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var txtHumidity: UILabel!
    @IBOutlet weak var txtWind: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    
    var favoritePlaces = Array<String>()
    
    var city: String = ""
    var isCityFav = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage (named: "bluebackground"), for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.clear
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        self.getWeatherForCity(city: city)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("HERE THEY ARE")
        print(self.favoritePlaces)
    }
    
    func getWeatherForCity (city:String){
        let weatherApi = CityWeatherApi()
        let weatherString = WeatherString()
        weatherApi.getWeatherForCity(city:city) { (result) in
        switch result {
            case .success(let weather):
                
                DispatchQueue.main.async {
                    self.detailCity.text = weather.name
                    
                    let celcius :Int = Int(weather.main.temp - 273.15)
                    let celciusMax :Int = Int(weather.main.tempMax - 273.15)
                    let celciusMin :Int = Int(weather.main.tempMin - 273.15)
                    self.detailTemp.text = String(celcius)+"°"
                    self.detailMaxTemp.text = String(celciusMax)+"°C"
                    self.detailMinTemp.text = String(celciusMin)+"°C"
                    
                    self.detailDesc.text = weather.weather[0].weatherDescription.capitalized
                    self.txtWind.text = String(weather.wind.speed) + " m/s"
                    self.txtHumidity.text = String(weather.main.humidity) + "%"
                   
                    self.txtTime.text = self.convertTimeZoneClock(timezone: weather.timezone)
                    
                    self.txtSunrise.text = (self.convertTimeZone(time: weather.sys.sunrise, timezone: weather.timezone))
                    self.txtSunset.text = (self.convertTimeZone(time: weather.sys.sunset, timezone: weather.timezone))
                    self.detailImage.image = UIImage(named: weatherString.checkWeatherImage(int: weather.weather[0].id))
                    }
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
    
    func convertTimeZone (time: Int, timezone: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        let localdate = dateFormatter.string(from: date as Date)
        
        return localdate
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
    
    @IBAction func btnAddHomescreen(_ sender: Any) {
        self.performSegue(withIdentifier: "detailVCToHomeVC", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVCToHomeVC" {
        let displayVC = segue.destination as! ViewController
        displayVC.homescreen = self.city
        }
        
        if segue.identifier == "detailVCToCompareVC" {
            let displayVC = segue.destination as! CompareViewController
            displayVC.favoritePlaces = self.favoritePlaces
            displayVC.CurrentCity = self.city
        }
    }
}
