//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 25.05.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var latitudeLabel: UILabel!
    @IBOutlet private weak var longitudeLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var tagLocationButton: UIButton!
    @IBOutlet private weak var getLocationButton: UIButton!
    
    //MARK: - State variables
    
    private let locationManager = CLLocationManager()
    
    private var location: CLLocation? {
        didSet {
            didSetLocation()
        }
    }
    
    private var address: String? {
        didSet {
            didSetAddress()
        }
    }
    
    private var updatingLocation = false {
        didSet {
            didSetUpdatingLocation()
        }
    }
    
    var updatingAddress = false {
        didSet {
            didSetUpdatingAddress()
        }
    }
    
    //MARK: - Update interface methods
    
    private func didSetLocation() {
        latitudeLabel.text = String(format: "%.8f", location?.coordinate.latitude ?? "")
        longitudeLabel.text = String(format: "%.8f", location?.coordinate.longitude ?? "")
        tagLocationButton.isHidden = (location == nil)
    }
    
    private func didSetAddress() {
        addressLabel.text = address
    }
    
    private func didSetUpdatingLocation() {
        if updatingLocation {
            messageLabel.text = "Scanning..."
            getLocationButton.setTitle("Stop Updating", for: .normal)
        } else {
            messageLabel.text = ""
            getLocationButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    private func didSetUpdatingAddress() {
        if updatingAddress {
            addressLabel.text = "Updating address..."
        }
    }
    
    //MARK: - Methods of CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Location manager finished with error: \(error)")
        
        let locationErrorCode = CLError.Code(rawValue: (error as NSError).code)
        
        if locationErrorCode == CLError.locationUnknown {
            return
        }
        
        stopLocationManager()
        showPossibleError(withCode: locationErrorCode)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let newLocation = locations.last else {
            print("Update location: no locations found")
            return
        }
        
        guard newLocation.timestamp.timeIntervalSinceNow > -5 else {
            return
        }
        
        guard newLocation.horizontalAccuracy > 0 else {
            return
        }
        
        guard self.location == nil ||
            self.location!.horizontalAccuracy > newLocation.horizontalAccuracy else {
            
            return
        }
        
        self.location = newLocation
        
        reverseGeocode(location: newLocation)

        if newLocation.horizontalAccuracy <= manager.desiredAccuracy {
            stopLocationManager()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        getLocation()
    }
 
    //MARK: - Actions
    
    @IBAction private func tagLocationButtonPressed() {
        
    }
    
    @IBAction private func getLocationButtonPressed() {
        
        if self.updatingLocation {
            stopLocationManager()
        } else {
            getLocation()
        }
    }
    
    //MARK: - Support private methods
    
    private func getLocation() {
        
        guard canRequestLocation() else {
            return
        }
        
        self.location = nil
        self.address = nil
        startLocationManager()
    }
    
    private func getAddress(from placemark: CLPlacemark) -> String {
        
        let countryPart = placemark.country ?? ""
        let cityPart = placemark.locality ?? ""
        let address1Part = placemark.thoroughfare ?? ""
        let address2Part = placemark.subThoroughfare ?? ""
        
        let address = "\(countryPart), \(cityPart)\n\(address1Part), \(address2Part)"
        
        return address
    }
    
    private func startLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        self.updatingLocation = true
    }
    
    private func stopLocationManager() {
        
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        self.updatingLocation = false
    }
    
    private func canRequestLocation() -> Bool {
        
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            showServiceDeniedController()
            return false
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
            
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        }
    }
    
    private func showServiceDeniedController() {
        
        let alertController = UIAlertController(
            title: "App is not allowed to use Location Services",
            message: "Please turn on Location Services usage in Settings for this App",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "Got it", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showPossibleError(withCode code:CLError.Code? = nil) {
        
        guard CLLocationManager.locationServicesEnabled() else {
            messageLabel.text = "Location Services disabled on device"
            return
        }

        if let code = code {
            switch code {
            case CLError.denied:
                messageLabel.text = "Location Services disabled for this app"
            default:
                messageLabel.text = "Error getting location"
            }
            
            return
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        updatingAddress = true
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: reverseGeocodingCompleted)
    }
    
    private func reverseGeocodingCompleted(placemarks: [CLPlacemark]?,
                                           _ error: Error?) {
        updatingAddress = false
        
        guard error == nil else {
            print("Reverse geocoding: error \(error.debugDescription)")
            return
        }
        
        guard let placemarks = placemarks else {
            print("Reverse geocoding: no placemarks")
            return
        }
        
        guard let placemark = placemarks.first else {
            print("Reverse geocoding: placemarks list is empty")
            return
        }
        
        address = getAddress(from: placemark)
    }
}

