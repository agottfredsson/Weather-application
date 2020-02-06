//
//  WeatherString.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-06.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import Foundation

struct WeatherString {


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
}
