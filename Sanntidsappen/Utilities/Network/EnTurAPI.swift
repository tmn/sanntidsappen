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

enum EnTurAPIType {
    case geocoder
    case journeyPlanner
    case stopRegister
}

class EnTurAPI {

    // Required header by En Tur
    private let headers: [String: String] = [
        "ET-Client-Name": "tmnio-sanntidsappen",
        "Content-Type": "application/json"
    ]

    private let baseURL: URL

    private var request: URLRequest!

    // Singletons for accessing different APIs
    static let geocoder = EnTurAPIGeocoder(apiType: .geocoder)

    static let journeyPlanner = EnTurAPIJourneyPlanner(apiType: .journeyPlanner)

    static let stopRegister = StopRegister(apiType: .stopRegister)

    fileprivate init(apiType: EnTurAPIType) {
        guard let sanntidsappenAPIs = Bundle.main.infoDictionary?["Sanntidsappen API"] as? [String: Any] else {
            preconditionFailure("Missing Sanntidsappen API in Info.plist")
        }

        guard let geocoderURLString = sanntidsappenAPIs["Geocoder"] as? String,
        let journeyPlannerURLString = sanntidsappenAPIs["Journey Planner"] as? String,
        let stopRegisterURLString = sanntidsappenAPIs["Stop Register"] as? String else {
            preconditionFailure("Missing API URLs")
        }

        switch (apiType) {
        case .geocoder: self.baseURL = URL(string: geocoderURLString)!
        case .journeyPlanner: self.baseURL = URL(string: journeyPlannerURLString)!
        case .stopRegister: self.baseURL = URL(string: stopRegisterURLString)!
        }
    }

    private func createRequestObject(path: String?) -> URLRequest {
        var _request: URLRequest

        if let path = path {
            let escapedSearchQuery = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

            // let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) {
            _request = URLRequest(url: URL(string: escapedSearchQuery, relativeTo: self.baseURL)!)
        } else {
            _request = URLRequest(url: self.baseURL)
        }

        for (headerField, value) in headers {
            _request.addValue(value, forHTTPHeaderField: headerField)
        }

        return _request
    }

}

extension EnTurAPI {

    fileprivate func get<T: Decodable>(path: String?, completionHandler: @escaping (Result<T>) -> Void) {
        request = createRequestObject(path: path)

        doRequest(request: request, completionHandler: completionHandler)
    }

    fileprivate func post<T: Decodable>(body: Dictionary<String, String>, completionHandler: @escaping (Result<T>) -> Void) {
        request = createRequestObject(path: nil)

        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.cachePolicy = .reloadIgnoringLocalCacheData

        doRequest(request: request, completionHandler: completionHandler)
    }

    fileprivate func doRequest<T: Decodable>(request: URLRequest, completionHandler: @escaping (Result<T>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(Result.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode),
                let data = data else {
                    completionHandler(Result.failure(NSError(domain: "Network Service", code: 1, userInfo: nil)))
                    return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(Result.success(decodedData))
            } catch let jsonError {
                completionHandler(Result.failure(jsonError))
            }
        }

        task.resume()
    }
}


// MARK: - EnTurAPIGeocoder

class EnTurAPIGeocoder: EnTurAPI {

    func getAutocompleteBusStop(searchQuery: String, completionHandler: @escaping (Result<Feature>) -> Void) {
        let path = String(format: "autocomplete?text=\(searchQuery)&layers=venue")

        get(path: path, completionHandler: completionHandler)
    }

    func getNearbyStops(latitude: Double, longitude: Double, completionHandler: @escaping (Result<Feature>) -> Void) {
        let path = "reverse?point.lat=\(latitude)&point.lon=\(longitude)&size=5&layers=venue"

        get(path: path, completionHandler: completionHandler)
    }

}


// MARK: - EnTurAPIJourneyPlanner

class EnTurAPIJourneyPlanner: EnTurAPI {

    func getStopPlace(for stop: Stop, completionHandler: @escaping (Result<StopInfo>) -> Void) {
        let dateFormatter = ISO8601DateFormatter()

        let query = "{ stopPlace(id: \"\(stop.properties.id)\") { id name estimatedCalls(startTime: \"\(dateFormatter.string(from: Date()))\", timeRange: 72100, numberOfDepartures: 50) { realtime aimedArrivalTime expectedArrivalTime date forBoarding destinationDisplay { frontText } quay { id name } serviceJourney { id journeyPattern { line { publicCode transportMode } } } } } }"

        let body = ["query": query]

        post(body: body, completionHandler: completionHandler)
    }

    func getJourney(journeyId: String, date: String, completionHandler: @escaping (Result<Journey.Journey>) -> Void) {
        let query = "{ serviceJourney(id: \"\(journeyId)\") { estimatedCalls(date: \"\(date)\") { aimedDepartureTime expectedDepartureTime quay { id name stopPlace { description } } } } }"

        let body = ["query": query]

        post(body: body, completionHandler: completionHandler)
    }

}


// MARK: - StopRegister

class StopRegister: EnTurAPI {

    func getQuayInformation(for stop: Stop, completionHandler: @escaping (Result<StopRegisterData>) -> Void) {
        let query = "{ stopPlace(id: \"\(stop.properties.id)\", stopPlaceType: onstreetBus) { id name { value } ... on StopPlace { quays { id compassBearing geometry { type coordinates } } } } }"
        let body = ["query": query]

        post(body: body, completionHandler: completionHandler)
    }

}
