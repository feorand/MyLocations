//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 22.09.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreLocation
import Dispatch
import CoreData

class TagLocationViewController: UITableViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var locationToEdit: Location? = nil

    var locationCoords: CLLocationCoordinate2D!
    var address: String?
    var date: Date!
    var categoryId = 0
    weak var context: NSManagedObjectContext!
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let location = locationToEdit {
            title = "Edit Location"
            descriptionTextView.text = location.locationDescription
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        recognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(recognizer)
        
        UpdateLabels()
    }

    @objc func hideKeyboard(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: location)
        
        if let indexPath = indexPath, indexPath.section != 0 || indexPath.row != 0 {
            descriptionTextView.resignFirstResponder()
        }
    }
    
    @IBAction func didPressCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressDone() {
        let locationForSave = Location(context: context)
        locationForSave.address = address
        locationForSave.date = date
        locationForSave.latitude = locationCoords.latitude
        locationForSave.longitude = locationCoords.longitude
        locationForSave.category = Int16(categoryId)
        locationForSave.locationDescription = descriptionTextView.text
        do {
            try context.save()
        } catch {
            context.raiseNotificationFor(error: error)
            return
        }
        
        let _ = SuccessView.red(view)
        
        let delayTimeInSeconds = 0.7
        let dismissSelf = { self.dismiss(animated: true, completion: nil) }
        executeAfter(delayTimeInSeconds, closure: dismissSelf)
    }
    
    @IBAction func didChooseCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        self.categoryId = controller.categoryId
        UpdateLabels()
    }
    
    private func UpdateLabels() {
        self.latitudeLabel.text = String(describing: self.locationCoords.latitude)
        self.longitudeLabel.text = String(describing: self.locationCoords.longitude)
        self.addressLabel.text = self.address
        self.dateLabel.text = dateFormatter.string(from: self.date)
        self.categoryLabel.text = LocationCategories.categories[categoryId]
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            return false
        }
        
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else {
            print("Empty segue ID")
            return
        }
        
        switch id {
        case "pickCategory":
            let controller = segue.destination as! CategoryPickerViewController
            controller.categoryId = self.categoryId
        default:
            print("Unknown segue")
            return
        }
    }
}

extension TagLocationViewController {
    func executeAfter(_ time: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: closure)
    }
}
