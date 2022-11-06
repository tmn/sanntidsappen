//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import Foundation

enum EnTurAPIType {
    case geocoder
    case journeyPlanner
    case stopRegister
}

class EnTurAPI {
    // Required header by En Tur
    private var headers: [String: String] = [
        "Content-Type": "application/json"
    ]

    private let baseURL: URL

    private var request: URLRequest!

    // Singletons for accessing different APIs
    static let geocoder = EnTurAPIGeocoder(apiType: .geocoder)

    static let journeyPlanner = EnTurAPIJourneyPlanner(apiType: .journeyPlanner)

    static let stopRegister = EnTurAPIStopRegister(apiType: .stopRegister)

    fileprivate init(apiType: EnTurAPIType) {
        guard let sanntidsappenClientName = Bundle.main.infoDictionary?["Sanntidsappen Client Name"] as? String else {
            preconditionFailure("Missing Sanntidsappen Client Name in Info.plist")
        }

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

        self.headers["ET-Client-Name"] = sanntidsappenClientName
    }

    private func createRequestObject(path: String?) -> URLRequest {
        var request: URLRequest

        if let path {
            let escapedSearchQuery = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            request = URLRequest(url: URL(string: escapedSearchQuery, relativeTo: self.baseURL)!)
        } else {
            request = URLRequest(url: self.baseURL)
        }

        for (headerField, value) in headers {
            request.addValue(value, forHTTPHeaderField: headerField)
        }

        return request
    }

}

extension EnTurAPI {
    enum EnTurAPIError: Error {
        case networkError
    }
}

extension EnTurAPI {

    fileprivate func get<T: Decodable>(path: String?) async throws -> T {
        request = createRequestObject(path: path)
        return try await asyncRequest(request: request)
    }

    fileprivate func post<T: Decodable>(body: Dictionary<String, String>) async throws -> T {
        request = createRequestObject(path: nil)

        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.cachePolicy = .reloadIgnoringLocalCacheData

        return try await asyncRequest(request: request)
    }

    fileprivate func asyncRequest<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            throw EnTurAPIError.networkError
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}


// MARK: - EnTurAPIGeocoder

class EnTurAPIGeocoder: EnTurAPI {

    func getAutocompleteBusStop(searchQuery: String) async throws -> Stops {
        let path = String(format: "autocomplete?text=\(searchQuery)&layers=venue")
        return try await get(path: path)
    }

    func getNearbyStops(latitude: Double, longitude: Double) async throws-> Stops {
        let path = "reverse?point.lat=\(latitude)&point.lon=\(longitude)&size=5&layers=venue"
        return try await get(path: path)
    }

}


// MARK: - EnTurAPIJourneyPlanner

class EnTurAPIJourneyPlanner: EnTurAPI {

    func getStopPlace(for stop: Stop) async throws -> JourneyStopPlace {
        let dateFormatter = ISO8601DateFormatter()

        let query = "{ stopPlace(id: \"\(stop.id)\") { id name estimatedCalls(startTime: \"\(dateFormatter.string(from: Date()))\", timeRange: 72100, numberOfDepartures: 50) { realtime aimedArrivalTime expectedArrivalTime date forBoarding destinationDisplay { frontText } quay { id name publicCode description } serviceJourney { id journeyPattern { line { id publicCode name transportMode } } } } } }"

        let body = ["query": query]

        return try await post(body: body)
    }

    func getJourney(journeyId: String, date: String) async throws -> Journey {
        let query = "{ serviceJourney(id: \"\(journeyId)\") { estimatedCalls(date: \"\(date)\") { aimedDepartureTime expectedDepartureTime quay { id name } } } }"
        let body = ["query": query]

        return try await post(body: body)
    }

}


// MARK: - StopRegister

class EnTurAPIStopRegister: EnTurAPI {

    func getQuayInformation(for stop: Stop) async throws -> StopRegister {
        let query = "{ stopPlace(id: \"\(stop.id)\", stopPlaceType: onstreetBus) { id name { value } ... on StopPlace { quays { id compassBearing geometry { type coordinates } } } } }"
        let body = ["query": query]

        return try await post(body: body)
    }

}
