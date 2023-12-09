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
    
    var locationManager = CLLocationManager()
    var lat = ""
    var long = ""
    var isLocationFetched = false
    var locationsList: [Location] = []
    
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
        let userLocation :CLLocation = locations[0] as CLLocation
        
        lat = "\(userLocation.coordinate.latitude)"
        long = "\(userLocation.coordinate.longitude)"
        
        guard let userLocation = locations.first?.coordinate else {
            return
        }
        
        if !isLocationFetched {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(region, animated: true)
            
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
                    
                    self.locationsList.append(Location(name: locationName, temperature: 25.0, coordinates: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.latitude)))

                    self.getWeatherData(location: "\(self.lat), \(self.long)") { weatherData in
                        if let weatherData = weatherData {
                            print("its calling...")
                            if let temp = weatherData.current?.temp_c {
                                self.addAnnotation(location: CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude),
                                                   title: "\(temp) C",
                                                   subtitle: "-1C (H: 4C, L: -5)")
                                
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
            
            // This shoudl be current weather condition image
            let icon = UIImage(systemName: "graduationcap.circle.fill")
            view.leftCalloutAccessoryView = UIImageView(image: icon)
            
            view.markerTintColor = pinColorForTemperature(25.0)
            view.tintColor = .systemRed
            
//            if let myAnnotation = annotation as? MyAnnotation {
//                view.glyphText = myAnnotation.glyphText
//            }
        }

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("this 1 working...")
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: LocationListViewCell.identifier, for: indexPath) as! LocationListViewCell
        cell.selectionStyle = .none
        cell.lblLocationName.text = "Location \(indexPath.item + 1)"
        cell.lblDescription.text = "Description \(indexPath.item + 1)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Index: \(indexPath.row)")
    }
    
    func newLocationSaved() {
        print("Save Clicked...")
        self.listTableView.reloadData()
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
