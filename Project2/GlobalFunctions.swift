//
//  GlobalFunctions.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-12-08.
//

import Foundation
import UIKit

extension UIImageView {
    func getWeatherImage(code: Int) {
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemBlue, .systemBlue])
        self.preferredSymbolConfiguration = config
        var imageCode = "sun.max.fill"
        
        for item in weatherIcons {
            if item.code == code {
                imageCode = item.text ?? ""
                break
            }
        }
        
        self.image = UIImage(systemName: imageCode)
        self.addSymbolEffect(.pulse)
    }
}

extension UIViewController {
    
    func getWeatherData(location: String, completion: @escaping (WeatherResponseModel?) -> Void) {
        guard let mainUrl = getApiURL(cityName: location) else {
            print("Invalid URL Request")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: mainUrl) { data, response, error in
            if let err = error {
                print("Error: \(err)")
                completion(nil)
                return
            }
            
            do {
                if let getData = data {
                    let decodedData = try JSONDecoder().decode(WeatherResponseModel.self, from: getData)
                    
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    func getApiURL(cityName: String) -> URL? {
        guard let url = (baseUrl + queryPart + "\(cityName)" + days + ending + apiKey ).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        return URL(string: url)
    }
    
}


