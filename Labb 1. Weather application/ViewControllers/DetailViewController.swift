//
//  DetailViewController.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-06.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import UIKit
import CoreMotion

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
    @IBOutlet weak var humidity: UIImageView!
    @IBOutlet weak var wind: UIImageView!
    
    @IBOutlet weak var sunset: UIImageView!
    @IBOutlet weak var sunrise: UIImageView!
    @IBOutlet weak var arrowDown: UIImageView!
    @IBOutlet weak var arrowUp: UIImageView!
    var favoritePlaces = Array<String>()
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var city: String = ""
    var isCityFav = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage (named: "bluebackground"), for: .default)
        navigationController?.navigationBar.barTintColor = UIColor.clear
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bluebackground")!)
        self.getWeatherForCity(city: city)
        self.removeViews()
    }
    
    func removeViews (){
        
        self.humidity.alpha = -9.0
        self.wind.alpha = -9.0
        self.txtHumidity.alpha = -9.0
        self.txtWind.alpha = -9.0
        self.detailImage.alpha = -9.0
        self.detailCity.transform = self.detailCity.transform.translatedBy(x: 0, y: -200)
        self.detailTemp.transform = self.detailTemp.transform.translatedBy(x: 0, y: -200)
        self.detailDesc.transform = self.detailDesc.transform.translatedBy(x: 0, y: -200)
        self.txtTime.transform = self.txtTime.transform.translatedBy(x: 0, y: -200)
        
        
        self.detailMaxTemp.transform = self.detailMaxTemp.transform.translatedBy(x: 200, y: 0)
        self.detailMinTemp.transform = self.detailMinTemp.transform.translatedBy(x: 200, y: 0)
        self.arrowUp.transform = self.arrowUp.transform.translatedBy(x: 200, y: 0)
        self.arrowDown.transform = self.arrowDown.transform.translatedBy(x: 200, y: 0)
        
        self.txtSunrise.transform = self.txtSunrise.transform.translatedBy(x: -200, y: 0)
        self.txtSunset.transform = self.txtSunset.transform.translatedBy(x: 200, y: 0)
        
        self.sunrise.transform = self.sunrise.transform.translatedBy(x: -200, y: 0)
        self.sunset.transform = self.sunset.transform.translatedBy(x: 200, y: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(self.favoritePlaces)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         self.animation()
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
    
       func animation (){
          
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.detailImage.alpha = 1.0
            self.txtHumidity.alpha = 1.0
            self.txtWind.alpha = 1.0
            self.humidity.alpha = 1.0
            self.wind.alpha = 1.0
            
            self.detailCity.transform = self.detailCity.transform.translatedBy(x: 0, y: 200)
            self.detailTemp.transform = self.detailTemp.transform.translatedBy(x: 0, y: 200)
            self.detailDesc.transform = self.detailDesc.transform.translatedBy(x: 0, y: 200)
            self.txtTime.transform = self.txtTime.transform.translatedBy(x: 0, y: 200)
            
            self.detailMaxTemp.transform = self.detailMaxTemp.transform.translatedBy(x: -200, y: 0)
            self.detailMinTemp.transform = self.detailMinTemp.transform.translatedBy(x: -200, y: 0)
            self.arrowUp.transform = self.arrowUp.transform.translatedBy(x: -200, y: 0)
            self.arrowDown.transform = self.arrowDown.transform.translatedBy(x: -200, y: 0)
            
            self.txtSunrise.transform = self.txtSunrise.transform.translatedBy(x: 200, y: 0)
            self.txtSunset.transform = self.txtSunset.transform.translatedBy(x: -200, y: 0)
            
            self.sunrise.transform = self.sunrise.transform.translatedBy(x: 200, y: 0)
            self.sunset.transform = self.sunset.transform.translatedBy(x: -200, y: 0)
            })
       
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.shakeMethod()
        }
        
    }
    
    func shakeMethod (){

        let outlets = [self.detailCity, self.detailDesc, self.detailImage, self.detailMaxTemp, self.detailMinTemp, self.detailTemp, self.humidity, self.wind, self.txtWind, self.detailTemp, self.humidity, self.wind, self.txtWind, self.txtHumidity, self.arrowUp, self.arrowDown, self.txtTime, self.sunset, self.sunrise, self.txtSunset, self.txtSunrise]
      
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior()
        collision = UICollisionBehavior()
        
        for i in 0...outlets.count-1 {
            gravity.addItem(outlets[i]!)
            collision.addItem(outlets[i]!)
        }

        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        
        collision.translatesReferenceBoundsIntoBoundary = true
    }
}
