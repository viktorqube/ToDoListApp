//
//  QuotesNetworkService.swift
//  ToDoListApp
//
//  Created by Viktor Qube on 22.12.2020.
//

import Foundation

protocol QuotesNetworkServiceProtocol {
    func getQuote(category: String, completion: @escaping (Quotes?, Error?) -> ())
}

class QuoteNetworkService: QuotesNetworkServiceProtocol {
    
    private struct Constants {
        struct APIDetails {
            static let APIScheme = "https"
            static let APIHost = "api.chucknorris.io"
            static let APIPath = "/jokes/random"
        }
    }
    
    func getQuote(category: String, completion: @escaping (Quotes?, Error?) -> ()) {
    
        
        
        var components = URLComponents()
        components.scheme = Constants.APIDetails.APIScheme
        components.host   = Constants.APIDetails.APIHost
        components.path   = Constants.APIDetails.APIPath
        
        //set URL parameters
        let parameters: [String: Any] = ["category" : "\(category)"]

        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        guard let url = components.url else {return}
        var request = URLRequest(url: url)
        URLSession.quoteFetchData(type: Quotes.self, request: request, completion: completion)
    
    }
    
    
}

extension URLSession {
    static func quoteFetchData<D: Decodable>(type: D.Type, request: URLRequest, completion: ((D?, Error?) -> Void)?) {
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
