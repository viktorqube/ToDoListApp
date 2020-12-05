//
//  NetworkService.swift
//  ToDoListApp
//
//  Created by Viktor Golovach on 30.11.2020.
//

import Foundation

protocol NetworkServiceProtocol {
    func getForecast(cityLatitude: Float, cityLongitude: Float, completion: @escaping (Forecast?, Error?) -> ())
}

class NetworkService: NetworkServiceProtocol {
    
    private struct Constants {
        struct APIDetails {
            static let APIScheme = "http"
            static let APIHost = "api.openweathermap.org"
            static let APIPath = "/data/2.5/weather"
        }
    }
    
    func getForecast(cityLatitude: Float, cityLongitude: Float, completion: @escaping (Forecast?, Error?) -> ()) {
    
        
        
        var components = URLComponents()
        components.scheme = Constants.APIDetails.APIScheme
        components.host   = Constants.APIDetails.APIHost
        components.path   = Constants.APIDetails.APIPath
        
        //set URL parameters
        let parameters: [String: Any] = ["lat" : "\(cityLatitude)",
                                         "lon" : "\(cityLongitude)",
                                         "appid" : "dcf67aae41a9255e8273edd2bcd48fef",
                                         "units " : "metric"]

        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        guard let url = components.url else {return}
        var request = URLRequest(url: url)
        URLSession.fetchData(type: Forecast.self, request: request, completion: completion)
    
    }
    
    
}

extension URLSession {
    static func fetchData<D: Decodable>(type: D.Type, request: URLRequest, completion: ((D?, Error?) -> Void)?) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(type, from: data)
                    DispatchQueue.main.async {
                        completion?(object, nil)
                    }
                } catch let error {
                    print(error)
                    DispatchQueue.main.async {
                        completion?(nil, error)
                    }
                }
            }
        }.resume()
    }
}
