//
//  ForecastSetup.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 30.11.2020.
//

import Foundation
import UIKit



struct Forecast: Decodable{
    let name: String
    let coord: Coordinates
    let main: Main
    let weather: [Weather]
    
}

struct Coordinates: Decodable {
    let lon: Float
    let lat: Float
}

struct Weather: Decodable{
    let main: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
}

protocol ForecastRenderable {
    var cityName: String {get}
    var imageUrl: URL {get}
    var temperature: Double {get}
    var conditions: String {get}
    var cityLon: Float {get}
    var cityLat: Float {get}
}



extension Forecast: ForecastRenderable {
    var cityLon: Float {
        return coord.lon
    }
    
    var cityLat: Float {
        return coord.lat
    }
    
    var conditions: String {
        return (weather.first?.main.description)!
    }
    

    var cityName: String {
        return name
    }
    
    var temperature: Double {
        return main.temp
    }
    
    var imageUrl: URL { URL(string: "http://openweathermap.org/img/wn/\(self.weather.first!.icon)@2x.png")!
    }
    
}
