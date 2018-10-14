//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

enum Result<Value> {

    case success(Value)
    case failure(Error)

}

struct EnTurAPI {

    static let baseURL = URL(string: "https://api.entur.org/api/geocoder/1.1/")!

    static let header: [String: String] = [
        "ET-Client-Name": "tmnio-sanntidsappen"
    ]

}

extension EnTurAPI {

    private static func get<T: Decodable>(url: URL, type: T.Type, completionHandler: @escaping (Result<T>) -> Void) {
        var request = URLRequest(url: url)

        for (headerField, value) in header {
            request.setValue(value, forHTTPHeaderField: headerField)
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completionHandler(Result.failure(error!))
            }

            guard let data = data else { return }

            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                completionHandler(Result.success(decodedData))
            } catch let jsonError {
                completionHandler(Result.failure(jsonError))
            }
        }.resume()
    }

}


extension EnTurAPI {

    public static func getAutocompleteBusStop<T: Decodable>(searchQuery: String, type: T.Type, completionHandler: @escaping (Result<T>) -> Void) {
        let escapedSearchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: String(format: "autocomplete?text=\(escapedSearchQuery ?? "")&layers=venue"), relativeTo: baseURL)!

        get(url: url, type: type, completionHandler: completionHandler)
    }

    public static func getNearbyStops<T: Decodable>(latitude: Double, longitude: Double, type: T.Type, completionHandler: @escaping (Result<T>) -> Void) {
        let url = URL(string: "reverse?point.lat=\(latitude)&point.lon=\(longitude)&size=5&layers=venue", relativeTo: baseURL)!

        get(url: url, type: type, completionHandler: completionHandler)
    }

}
