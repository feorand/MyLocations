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
    
    //MARK: - State variables
    
    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var updatingLocation = false
    
    //MARK: - Methods of CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager finished with error: \(error)")
        let locationError = CLError.Code(rawValue: (error as NSError).code)
        
        if locationError == CLError.locationUnknown {
            return
        }
        
        stopLocationManager()
        updateLabels(withErrorCode: locationError)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
        self.updatingLocation = false
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getLocation()
    }

    //MARK: - Actions
    
    @IBAction private func tagLocationButtonPressed() {
        
    }
    
    @IBAction private func getLocationButtonPressed() {
        locationManager.delegate = self
        
        getLocation()
    }
    
    //MARK: - Support private methods
    private func getLocation() {
        guard canRequestLocation() else {
            return
        }
        
        startLocationManager()
        updateLabels()
    }
    
    private func startLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        self.updatingLocation = true
    }
    
    private func stopLocationManager() {
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
    
    private func updateLabels(withErrorCode errorCode:CLError.Code? = nil) {
        if self.updatingLocation {
            latitudeLabel.text = "Updating"
            longitudeLabel.text = "Updating"
        } else {
            latitudeLabel.text = String(format: "%.8f", location?.coordinate.latitude ?? "Unknown")
            longitudeLabel.text = String(format: "%.8f", location?.coordinate.longitude ?? "Unknown")
        }
        
        tagLocationButton.isHidden = (location == nil)
        
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
        
        messageLabel.text = self.updatingLocation ?
            "Scanning..." :
            ""
    }
    
}

