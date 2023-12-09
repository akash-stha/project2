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
    var max: Float
    var min: Float
    var code: Int
    var coordinates: CLLocationCoordinate2D
}

struct WeatherResponseModel: Decodable {
    let location: LocationName?
    let current: Current?
    let forecast: Forecast?
}

struct LocationName: Decodable {
    let name: String?
    let lat: Double?
    let lon: Double?
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
    let forecastday: [ForecastDay]
}

struct ForecastDay: Decodable {
    let date: String
    let day : Day
}

struct Day: Decodable {
    let maxtemp_c: Float
    let mintemp_c: Float
    let condition: Condition
}

