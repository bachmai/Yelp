//
//  YelpManager.swift
//  Yelp
//
//  Created by Bach Mai on 3/24/22.
//

import Foundation



class YelpManager {
    static func searchBusiness(term: String, completion: @escaping([BusinessDetailObj]?, String?) -> Void) {
        var components = URLComponents(string: NetworkURLConstants.businessSearch)!
        components.queryItems = [
        URLQueryItem(name: "term", value: term),
        URLQueryItem(name: "location", value: "350 5th Ave, New York, NY 10118"),
        URLQueryItem(name: "limit", value: "10")
        ]
        guard let url = components.url else {
            completion(nil, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = YelpTokenConstants.headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode,
               let data = data {
                if responseCode >= 200, responseCode < 300 {
                    do {
                        let businessData = try JSONDecoder().decode(BusinessSearchResponse.self, from: data)
                        completion(businessData.businesses, nil)
                    } catch {
                        completion(nil, "Error encountered in parsing response")
                    }
                } else {
                    completion(nil, "Received invalid code: \(responseCode)")
                }
            }
        }
        task.resume()
    }
    
    static func getBusinessDetails(bizID: String, completion: @escaping(BusinessDetailsResponse?, String?) -> Void) {
        guard let url = URL(string: "\(NetworkURLConstants.businessDetails)\(bizID)") else {
            completion(nil, "Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = YelpTokenConstants.headers
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, "Error: \(error.localizedDescription)")
                return
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode,
               let data = data {
                if responseCode >= 200, responseCode < 300 {
                    do {
                        let businessData = try JSONDecoder().decode(BusinessDetailsResponse.self, from: data)
                        completion(businessData, nil)
                    } catch {
                        completion(nil, "Error encountered in parsing response")
                    }
                } else {
                    completion(nil, "Received invalid code: \(responseCode)")
                }
            }
        }
        task.resume()
    }
}
