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

//struct WeatherResponseModel : Decodable {
//    let location : LocationName?
//    let current : Current?
//    let forecast : Forecast?
//}

//struct LocationName : Decodable {
//    let name : String?
//    let region : String?
//    let country : String?
//    let lat : Double?
//    let lon : Double?
//    let tz_id : String?
//    let localtime_epoch : Int?
//    let localtime : String?
//}
//
//struct Current : Decodable {
//    let last_updated_epoch : Int?
//    let last_updated : String?
//    let temp_c : Double?
//    let temp_f : Double?
//    let is_day : Int?
//    let condition : Condition?
//}
//
//struct Forecast : Decodable {
//    let forecastday : [Forecastday]?
//}
//
//struct Condition : Decodable {
//    let text : String?
//    let code : Int?
//}
//
//struct Forecastday : Decodable {
//    let date : String?
//    let date_epoch : Int?
//    let day : Day?
//}
//
//struct Day : Decodable {
//    let maxtemp_c : Double?
//    let maxtemp_f : Double?
//    let mintemp_c : Double?
//    let mintemp_f : Double?
//}

struct WeatherResponseModel: Decodable {
    let location: LocationName?
    let current: Current?
    let forecast: Forecast?
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

