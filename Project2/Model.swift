//
//  Model.swift
//  Project2
//
//  Created by Akash Shrestha on 2023-12-08.
//

import Foundation
import MapKit

struct Location {
    var name: String
    var temperature: Double
    var coordinates: CLLocationCoordinate2D
}

struct WeatherResponseModel: Decodable {
    let location: LocationName?
    let current: Current?
//    let forecast: Forecast?
}

struct LocationName: Decodable {
    let name: String?
}

struct Current: Decodable {
    let temp_c: Float?
    let temp_f: Float?
    let condition: Condition?
    let feelslike_c: Float?
}

struct Condition: Decodable {
    let text: String?
    let code: Int?
}

struct Forecast: Decodable {
    let forecastDay: [ForecastDay]
}

struct ForecastDay: Decodable {
    let day : Day
}

struct Day: Decodable {
    let maxtemp_c: Float
    let mintemp_c: Float
}

