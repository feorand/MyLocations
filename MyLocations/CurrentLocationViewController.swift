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
    private var location: CLLocation?
    private var address: String?
    private var updatingLocation = false
    private var updatingPlacemark = false
    
    //MARK: - Methods of CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Location manager finished with error: \(error)")
        
        let locationError = CLError.Code(rawValue: (error as NSError).code)
        
        if locationError == CLError.locationUnknown {
            return
        }
        
        stopLocationManager()
        updateUI(withErrorCode: locationError)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let newLocation = locations.last!
        
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

        if newLocation.horizontalAccuracy <= manager.desiredAccuracy {
            stopLocationManager()
        }
        
        let geocoder = CLGeocoder()
        updatingPlacemark = true
        geocoder.reverseGeocodeLocation(newLocation, completionHandler: {providedPlacemarks, error in
            
            self.updatingPlacemark = false
            
            guard error == nil else {
                print("Reverse geocoding: error \(error.debugDescription)")
                return
            }
            
            guard let placemarks = providedPlacemarks else {
                print("Reverse geocoding: no placemarks")
                return
            }
            
            guard let placemark = placemarks.first else {
                print("Reverse geocoding: placemarks list is empty")
                return
            }
            
            self.address = self.getAddress(from: placemark)
            self.updateUI()
        })
        
        updateUI()
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
            updateUI()
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
        updateUI()
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
    
    private func updateUI(withErrorCode errorCode:CLError.Code? = nil) {
        
        guard CLLocationManager.locationServicesEnabled() else {
            messageLabel.text = "Location Services disabled on device"
            return
        }

        if let errorCode = errorCode {
            switch errorCode {
            case CLError.denied:
                messageLabel.text = "Location Services disabled for this app"
            default:
                messageLabel.text = "Error getting location"
            }
            return
        }

        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagLocationButton.isHidden = false
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            tagLocationButton.isHidden = true
        }

        if updatingLocation {
            messageLabel.text = "Scanning..."
            getLocationButton.setTitle("Stop Updating", for: .normal)
        } else {
            messageLabel.text = ""
            getLocationButton.setTitle("Get My Location", for: .normal)
        }
        
        addressLabel.text = updatingPlacemark ? "Updating address" : address
    }
}

