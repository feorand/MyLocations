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
    
    @IBAction func tagLocationButtonPressed() {
    
    }
    
    @IBAction func getLocationButtonPressed() {
        
        prepareCoreLocationOperation()
        
        if locationManager.delegate == nil {
            return
        }
        
        locationManager.requestLocation()
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
        
        locationManager.delegate = self
    }
    
    func updateLabels() {
        if let location = self.location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            messageLabel.text = ""
            tagLocationButton.isHidden = false
        } else {
            latitudeLabel.text = "Unknown"
            longitudeLabel.text = "Unknown"
            messageLabel.text = "Tap Get My Location to begin"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fall with error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last!
        updateLabels()
    }
}

