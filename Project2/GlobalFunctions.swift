//
//  GlobalFunctions.swift
//  Lab03
//
//  Created by Akash Shrestha on 2023-12-08.
//

import Foundation
import UIKit

extension UIViewController {
    func getWeatherImage(code: Int) -> UIImage {
        let config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemBlue, .systemBlue])
        self.imgWeatherConition.preferredSymbolConfiguration = config
        var imageCode = "sun.max.fill"
        
        for item in weatherIcons {
            if item.code == code {
                imageCode = item.text ?? ""
                break
            }
        }
        
        self.imgWeatherConition.image = UIImage(systemName: imageCode)
        self.imgWeatherConition.addSymbolEffect(.pulse)
    }
}


