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
    
    let locationManager = CLLocationManager()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        messageLabel.text = "Location Updated"
        
        let location = locations.last!
        latitudeLabel.text = "\(location.coordinate.latitude)"
        longitudeLabel.text = "\(location.coordinate.longitude)"
    }
}

