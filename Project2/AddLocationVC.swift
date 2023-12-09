//
//  AddLocationVC.swift
//  Project2
//
//  Created by Akash Shrestha on 2023-12-08.
//

import UIKit
import CoreLocation

protocol NewLocationSaved {
    func newLocationSaved(weatherData: WeatherResponseModel)
}

class AddLocationVC: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var imgWeatherConition: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var imgSearch: UIImageView!
    
    var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var delegate: NewLocationSaved?
    var savedWeatherData: WeatherResponseModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        searchButtonActon()
        textConfig()
        getCurrentLocation()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Save button
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        // Cancel button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        // Set the navigation bar items
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func searchButtonActon() {
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(searchImgButtonTapped(_:)))
        imgSearch.isUserInteractionEnabled = true
        imgSearch.addGestureRecognizer(searchTapGesture)
    }
    
    func textConfig() {
        tfLocation.delegate = self
        tfLocation.autocapitalizationType = .words
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
                
        getWeatherData(location: "\(lat), \(long)") { weatherData in
            if let weatherData = weatherData {
                self.lblCityName.text = weatherData.location?.name ?? ""
                self.lblTemp.text = "\(weatherData.current?.temp_c ?? 0.0)"
                self.imgWeatherConition.getWeatherImage(code: weatherData.current?.condition?.code ?? 0)
            } else {
            print("Error Occured")
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherData(location: tfLocation.text ?? "") { weatherData in
            if let weatherData = weatherData {
                self.lblCityName.text = weatherData.location?.name ?? ""
                self.lblTemp.text = "\(weatherData.current?.temp_c ?? 0.0)"
                self.imgWeatherConition.getWeatherImage(code: weatherData.current?.condition?.code ?? 0)
                
                self.savedWeatherData = weatherData
            } else {
            print("Error Occured")
            }
        }
        
        tfLocation.text = ""
        tfLocation.resignFirstResponder()
        return true
    }
    
    @objc func searchImgButtonTapped(_ sender: UITapGestureRecognizer) {
        if tfLocation.text?.isEmpty != true {            
            getWeatherData(location: tfLocation.text ?? "") { weatherData in
                if let weatherData = weatherData {
                    self.lblCityName.text = weatherData.location?.name ?? ""
                    self.lblTemp.text = "\(weatherData.current?.temp_c ?? 0.0)"
                    self.imgWeatherConition.getWeatherImage(code: weatherData.current?.condition?.code ?? 0)
                    
                    self.savedWeatherData = weatherData
                } else {
                print("Error Occured")
                }
            }
            
            tfLocation.text = ""
            tfLocation.resignFirstResponder()
        } else {
            tfLocation.shake()
        }
    }
    
    @objc private func saveButtonTapped() {
        self.dismiss(animated: true) {
            if let data = self.savedWeatherData {
                self.delegate?.newLocationSaved(weatherData: data)
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Textfield Shake
extension UITextField {
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        
        let fromPoint = CGPoint(x: self.center.x - 5, y: self.center.y)
        let toPoint = CGPoint(x: self.center.x + 5, y: self.center.y)
        animation.fromValue = NSValue(cgPoint: fromPoint)
        animation.toValue = NSValue(cgPoint: toPoint)
        
        self.layer.add(animation, forKey: "position")
    }
}
