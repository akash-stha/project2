//
//  Constants.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-11-18.
//

import Foundation

let baseUrl = "https://api.weatherapi.com/v1/forecast.json"
let queryPart = "?q="
let days = "&days=1"
let ending = "&key="
let apiKey = "f4eb685e9ecb49e0841183431231811"


let weatherIcons: [Condition] = [
    Condition(text: "sun.max.fill", code: 1000),
    Condition(text: "cloud", code: 1003),
    Condition(text: "cloud.fog", code: 1006),
    Condition(text: "cloud.snow", code: 1219),
    Condition(text: "cloud.heavyrain", code: 1030)
]
