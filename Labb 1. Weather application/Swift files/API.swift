//
//  API.swift
//  Labb 1. Weather application
//
//  Created by Anton Gottfredsson on 2020-02-05.
//  Copyright © 2020 Anton Gottfredsson. All rights reserved.
//

import Foundation

struct CityWeatherApi {


let ApiKey :String = "&APPID=03fcc5fcb42ae531e62750a95cb63c66"
let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?q="
    

    func getWeatherForCity(city: String, completion: @escaping (Result<Weather, Error>) -> Void) {
    
    //url
        
    let urlString = baseURL + city + ApiKey //+ "random"
    guard let url: URL = URL(string: urlString) else { return }
    
    //Request
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let unwrappedError = error {
            print("Något gick fel. Error: \(unwrappedError)")
            
            return
        }
        if let unwrappedData = data {
            print("we got data! \(String(data: unwrappedData, encoding:String.Encoding.utf8) ?? "No data")")
            do {
                let decoder = JSONDecoder()
                let weather: Weather = try decoder.decode(Weather.self, from: unwrappedData)
                completion(.success(weather))
                
            } catch {
                print("Couldn't parse JSON..")
                
            }
            
        }
    }
    
    //Starta task
    task.resume()
}
}
