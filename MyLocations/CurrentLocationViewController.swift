//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 25.05.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    var shouldRequestLocation = false
    var updatingLocation = false
    
    @IBAction func tagLocationButtonPressed() {
    
    }
    
    @IBAction func getLocationButtonPressed() {
        
        prepareCoreLocationOperation()
        
        if !shouldRequestLocation {
            return
        }
        
        locationManager.requestLocation()
        self.updatingLocation = true
        updateLabels()
    }
    
    private func prepareCoreLocationOperation() {
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:

            let alertController = UIAlertController(title: "App is not allowed to use Location Services", message: "Please turn on Location Services usage in Settings for this App", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
            
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            CLLocationManager.locationServicesEnabled()
        default:
            break;
        }
        
        shouldRequestLocation = true
    }
    
    func updateLabels(withErrorCode errorCode:CLError.Code? = nil) {
        if self.updatingLocation {
            latitudeLabel.text = "Updating"
            longitudeLabel.text = "Updating"
        } else {
            latitudeLabel.text = String(format: "%.8f", location?.coordinate.latitude ?? "Unknown")
            longitudeLabel.text = String(format: "%.8f", location?.coordinate.longitude ?? "Unknown")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager finished with error: \(error)")
        let code = (error as NSError).code
        
        if code == CLError.locationUnknown.rawValue {
            return
        }
        
        updateLabels(withErrorCode: CLError.Code(rawValue: code))
        self.updatingLocation = false
        self.shouldRequestLocation = false
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
        self.updatingLocation = false
        updateLabels()
    }
}

