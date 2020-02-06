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
    var city: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.clear
        
    //    self.navigationController?.navigationBar.setBackgroundImage(UIImage (named: "bluebackground"), for: .default)
        self.navigationController?.navigationBar.topItem?.title = " "
        
        
  
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        self.getWeatherForCity(city: city)
        print(city)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                    
                    self.detailCity.text = weather.name
                    self.detailTemp.text = String(celcius)+"°"
                    self.detailMaxTemp.text = String(celciusMax)+"°C"
                    self.detailMinTemp.text = String(celciusMin)+"°C"
                    self.detailDesc.text = weather.weather[0].weatherDescription
                    
                    self.detailImage.image = UIImage(named: weatherString.checkWeatherImage(int: weather.weather[0].id))
                    }
            
            case .failure(let error): print("Error \(error)")
            }
        }
    }
}
