//
//  DarkSkyWeatherService.swift
//  GeoCalculator
//
//  Created by Cheng Li on 11/17/17.
//  Copyright © 2017 Cheng Li. All rights reserved.
//

import Foundation

let sharedDarkSkyInstance = DarkSkyWeatherService()

class DarkSkyWeatherService: WeatherService {
    
    let API_BASE = "https://api.darksky.net/forecast/"
    var urlSession = URLSession.shared
    
    class func getInstance() -> DarkSkyWeatherService {
        return sharedDarkSkyInstance
    }
    
    func getWeatherForDate(date: Date, forLocation location: (Double, Double),
                           completion: @escaping (Weather?) -> Void)
    {
        
        // TODO: concatentate the complete endpoint URL here.
        let urlStr = API_BASE + DARK_SKY_WEATHER_API_KEY + "/\(location.0),\(location.1),\(Int(date.timeIntervalSince1970))"
        let url = URL(string: urlStr)
        
        let task = self.urlSession.dataTask(with: url!) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let _ = response {
                let parsedObj : Dictionary<String,AnyObject>!
                do {
                    parsedObj = try JSONSerialization.jsonObject(with: data!, options:
                        .allowFragments) as? Dictionary<String,AnyObject>
                    
                    guard let currently = parsedObj["currently"],
                        let summary = currently["summary"] as? String,
                        let iconName = currently["icon"] as? String,
                        let temperature = currently["temperature"] as? Double
                    
                    else {
                        completion(nil)
                        return
                    }
                    
                    let weather = Weather(iconName: iconName, temperature: temperature,
                                          summary: summary)
                    completion(weather)
                    
                }  catch {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
}	
