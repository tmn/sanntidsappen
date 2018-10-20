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

class EnTurAPI {

    // Static paths to En Tur APIs
    // TODO: move URLs into Build settings
    fileprivate static let geocoderURL = URL(string: "https://api.entur.org/api/geocoder/1.1/")!

    fileprivate static let journeyPlannerURL = URL(string: "https://api.entur.org/journeyplanner/2.0/index/graphql")!

    // Required header by En Tur
    fileprivate let header: [String: String] = [
        "ET-Client-Name": "tmnio-sanntidsappen"
    ]

    fileprivate var request: URLRequest

    // Singletons for accessing different APIs
    static let geocoder = EnTurAPIGeocoder()

    static let journeyPlanner = EnTurAPIJourneyPlanner()

    fileprivate init(baseURL: URL) {
        self.request = URLRequest(url: baseURL)

        for (headerField, value) in header {
            request.setValue(value, forHTTPHeaderField: headerField)
        }
    }

}

extension EnTurAPI {

    func get<T: Decodable>(path: String?, type: T.Type, completionHandler: @escaping (Result<T>) -> Void) {
        if let path = path {
            request.url = URL(string: path, relativeTo: request.url)!
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

    func post<T: Decodable>(path: String?, body: Dictionary<String, String>, type: T.Type, completionHandler: @escaping (Result<T>) -> Void) {
        if let path = path {
            request.url = URL(string: path, relativeTo: request.url)!
        }

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.cachePolicy = .reloadIgnoringLocalCacheData

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


// MARK: - EnTurAPIGeocoder

class EnTurAPIGeocoder: EnTurAPI {

    fileprivate init() {
        super.init(baseURL: EnTurAPI.geocoderURL)
    }

}

extension EnTurAPIGeocoder {

    func getAutocompleteBusStop(searchQuery: String, completionHandler: @escaping (Result<Feature>) -> Void) {
        let escapedSearchQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        let path = String(format: "autocomplete?text=\(escapedSearchQuery ?? "")&layers=venue")

        get(path: path, type: Feature.self, completionHandler: completionHandler)
    }

    func getNearbyStops(latitude: Double, longitude: Double, completionHandler: @escaping (Result<Feature>) -> Void) {
        let path = "reverse?point.lat=\(latitude)&point.lon=\(longitude)&size=5&layers=venue"

        get(path: path, type: Feature.self, completionHandler: completionHandler)
    }

}


// MARK: - EnTurAPIJourneyPlanner

class EnTurAPIJourneyPlanner: EnTurAPI {

    fileprivate init() {
        super.init(baseURL: EnTurAPI.journeyPlannerURL)
    }

}

extension EnTurAPIJourneyPlanner {

    func getStopPlace(for stop: Stop, completionHandler: @escaping (Result<StopInfo>) -> Void) {
        let dateFormatter = ISO8601DateFormatter()

        let nowISO8601 = dateFormatter.string(from: Date())

        let query = "{ stopPlace(id: \"\(stop.properties.id)\") { id name estimatedCalls(startTime: \"\(nowISO8601)\", timeRange: 72100, numberOfDepartures: 50) { realtime aimedArrivalTime expectedArrivalTime forBoarding destinationDisplay { frontText } quay { id name } serviceJourney { journeyPattern { line { publicCode transportMode } } } } } }"

        let body = ["query": query]

        post(path: nil, body: body, type: StopInfo.self, completionHandler: completionHandler)
    }

}
