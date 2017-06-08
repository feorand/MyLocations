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
    enum AppState {
        case idle, updateStarted, updateFinished
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagLocationButton: UIButton!
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var state: AppState = .idle
    var shouldRequestLocation = false
    
    @IBAction func tagLocationButtonPressed() {
    
    }
    
    @IBAction func getLocationButtonPressed() {
        
        prepareCoreLocationOperation()
        
        if !shouldRequestLocation {
            return
        }
        
        locationManager.requestLocation()
        state = .updateStarted
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
        switch self.state {
        case .updateStarted:
            latitudeLabel.text = "Updating"
            longitudeLabel.text = "Updating"
            tagLocationButton.isHidden = false
        case .updateFinished:
            latitudeLabel.text = String(format: "%.8f", location?.coordinate.latitude ?? "Unknown")
            longitudeLabel.text = String(format: "%.8f", location?.coordinate.longitude ?? "Unknown")
            tagLocationButton.isHidden = false
        case .idle:
            return
        }
        
        if let errorCode = errorCode {
//            switch errorCode {
//            case CLError
//            }
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
        state = .updateFinished
        shouldRequestLocation = false
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
        state = .updateFinished
        updateLabels()
    }
}

