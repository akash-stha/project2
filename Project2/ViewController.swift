//
//  ViewController.swift
//  Project2
//
//  Created by Akash Shrestha on 2023-12-08.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var lblSavedLocationMsg: UILabel!
    
    var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var isLocationFetched = false
    var locationsList = [Location]()
    var tempInCelcius: Float?
    var weatherDetails: WeatherResponseModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableConfig()
        getCurrentLocation()
        setupToolbar()
        getCurrentLocation()
        mapView.delegate = self
    }
    
    // MARK: Table View Configuration
    private func tableConfig() {
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(LocationListViewCell.nib(), forCellReuseIdentifier: LocationListViewCell.identifier)
    }
    
    // MARK: Toolbar Configuration
    func setupToolbar() {
        let toolbar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let addLocationButton = UIBarButtonItem(
            title: "Add Location",
            style: .plain,
            target: self,
            action: #selector(addLocationButtonTapped)
        )
        
        setToolbarItems([toolbar, addLocationButton], animated: true)
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc func addLocationButtonTapped() {
        let vc = UIStoryboard(name: "AddLocation", bundle: nil).instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        vc.delegate = self
        let vcWithNav = UINavigationController(rootViewController: vc)
        self.present(vcWithNav, animated: true)
    }
    
    // MARK: Current Location Configuration
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
        
        guard let userLocation = locations.first?.coordinate else {
            return
        }
        
        if !isLocationFetched {
            setMapRegion(lat: userLocation.latitude, long: userLocation.longitude)
            
            lat = "\(userLocation.latitude)"
            long = "\(userLocation.longitude)"
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    // MARK: Accessing the location name from the placemark
                    let locationName = placemark.name ?? ""
                    print("Location Name: \(locationName)")
                    self.getWeatherData(location: "\(self.lat), \(self.long)") { weatherData in
                        if let weatherData = weatherData {
                            self.weatherDetails = weatherData
                            self.tempInCelcius = weatherData.current?.temp_c
                            if let temp = weatherData.current?.temp_c {
                                self.addAnnotation(location: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude),
                                                   title: "\(temp) C",
                                                   subtitle: "")
                                
                                self.locationsList.append(Location(name: locationName, temperature: Double(temp), max: weatherData.forecast?.forecastday.first?.day.maxtemp_c ?? 0.0, min: weatherData.forecast?.forecastday.first?.day.mintemp_c ?? 0.0, code: weatherData.current?.condition?.code ?? 0, coordinates: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude)))
                                self.listTableView.reloadData()
                            }
                        } else {
                            print("Error Occured")
                        }
                    }
                }
            }
            
            isLocationFetched = true
            locationManager.stopUpdatingLocation()
            
        }
        
        print(lat)
        print(long)
    }
    
    func addAnnotation(location: CLLocation, title: String, subtitle: String) {
        let annotation = MyAnnotation(coordinate: location.coordinate, title: title, subtitle: subtitle)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKMarkerAnnotationView
        
        if let deqeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotaionView") as? MKMarkerAnnotationView {
            deqeuedView.annotation = annotation
//            deqeuedView.annotation?.title = "Partly Cloudly"
//            deqeuedView.annotation?.subtitle = "Feels Like -5C"
            view = deqeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 10)
            
            let button = UIButton(type: .detailDisclosure)
            button.tag = 1
            view.rightCalloutAccessoryView = button
            
//            This shoudl be current weather condition image
            let icon = UIImage(systemName: "graduationcap.circle.fill")
            view.leftCalloutAccessoryView = UIImageView(image: icon)
            
//            let weatherImageView = UIImageView()
//            weatherImageView.getWeatherImage(code: weatherDetails?.current?.condition?.code ?? 0)
//            view.leftCalloutAccessoryView = weatherImageView
            
            view.markerTintColor = pinColorForTemperature(Double(tempInCelcius ?? 0.0))
            view.tintColor = .systemRed
            
//            if let myAnnotation = annotation as? MyAnnotation {
//                view.glyphText = myAnnotation.glyphText
//            }
        }

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let vc = UIStoryboard(name: "WeatherDetails", bundle: nil).instantiateViewController(withIdentifier: "WeatherDetailsVC") as! WeatherDetailsVC
        vc.getWeatherDetails = weatherDetails
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pinColorForTemperature(_ temperature: Double) -> UIColor {
        switch temperature {
        case ...(-1):
            return .purple
        case 0...11:
            return .blue
        case 12...16:
            return .cyan
        case 17...24:
            return .yellow
        case 25...30:
            return .orange
        default:
            return .red
        }
    }

    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, NewLocationSaved {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if locationsList.count != 0 {
            lblSavedLocationMsg.isHidden = true
        } else {
            lblSavedLocationMsg.isHidden = false
        }
        
        return locationsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: LocationListViewCell.identifier, for: indexPath) as! LocationListViewCell
        cell.selectionStyle = .none
        let model = locationsList[indexPath.item]
        cell.lblLocationName.text = model.name
        cell.weatherIcon.getWeatherImage(code: model.code)
        cell.lblDescription.text = "\(model.temperature)C (H: \(model.max) L: \(model.min))"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = locationsList[indexPath.item]
        self.addAnnotation(location: CLLocation(latitude: model.coordinates.latitude, longitude: model.coordinates.longitude),
                           title: "\(model.temperature) C",
                           subtitle: "")
        setMapRegion(lat: model.coordinates.latitude, long: model.coordinates.longitude)
    }
    
    func newLocationSaved(weatherData: WeatherResponseModel) {
        self.weatherDetails = weatherData
        self.setMapRegion(lat: weatherData.location?.lat ?? 0.0, long: weatherData.location?.lon ?? 0.0)
        self.addAnnotation(location: CLLocation(latitude: weatherData.location?.lat ?? 0.0, longitude: weatherData.location?.lon ?? 0.0),
                           title: "\(weatherData.current?.temp_c ?? 0.0) C",
                           subtitle: "")
        self.locationsList.append(Location(name: weatherData.location?.name ?? "", temperature: Double(weatherData.current?.temp_c ?? 0.0), max: weatherData.forecast?.forecastday.first?.day.maxtemp_c ?? 0.0, min: weatherData.forecast?.forecastday.first?.day.mintemp_c ?? 0.0, code: weatherData.current?.condition?.code ?? 0, coordinates: CLLocationCoordinate2D(latitude: weatherData.location?.lat ?? 0.0, longitude: weatherData.location?.lon ?? 0.0)))
        self.listTableView.reloadData()
    }
    
    func setMapRegion(lat: CLLocationDegrees, long: CLLocationDegrees) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
    
}

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var glyphText: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, glyphText: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.glyphText = glyphText
        super.init()
    }
}
