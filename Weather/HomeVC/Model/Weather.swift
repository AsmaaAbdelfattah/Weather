//
//  Weather.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import Foundation
struct WeatherResponse: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: IntOrString?
    let message:String?
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
struct Main: Codable {
    let temp: Double
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Int?
    let humidity: Int?
    let sea_level: Int?
    let grnd_level: Int?
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
    let gust: Double?
}

struct Sys: Codable {
    let country: String?
    let sunrise: Int?
    let sunset: Int?
    let type: Int?
    let id: Int?
}


struct Clouds: Codable {
    let all: Int?
}


enum IntOrString: Codable, Equatable {
    case intValue(Int)
    case stringValue(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self = .intValue(intValue)
            return
        }
        
        if let stringValue = try? container.decode(String.self) {
            self = .stringValue(stringValue)
            return
        }
        
        throw DecodingError.typeMismatch(IntOrString.self,
                                         DecodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Expected Int or String"))
    }
    
    // Implement Equatable for comparison with Int
    static func == (lhs: IntOrString, rhs: Int) -> Bool {
        switch lhs {
        case .intValue(let value):
            return value == rhs
        case .stringValue(let string):
            return Int(string) == rhs
        }
    }
    
    // Implement Equatable for comparison with String (optional)
    static func == (lhs: IntOrString, rhs: String) -> Bool {
        switch lhs {
        case .intValue(let value):
            return String(value) == rhs
        case .stringValue(let string):
            return string == rhs
        }
    }
}
