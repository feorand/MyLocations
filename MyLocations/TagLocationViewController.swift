//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 22.09.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreLocation

class TagLocationViewController: UITableViewController {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var location: CLLocationCoordinate2D!
    var address: String?
    var date: Date!
    var categoryId = 0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UpdateLabels()
    }
    
    @IBAction func didPressCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressDone() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func UpdateLabels() {
        self.latitudeLabel.text = String(describing: self.location.latitude)
        self.longitudeLabel.text = String(describing: self.location.longitude)
        self.addressLabel.text = self.address
        self.dateLabel.text = dateFormatter.string(from: self.date)
        self.categoryLabel.text = LocationCategories.categories[categoryId]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 2:
            return false
        default:
            return true
        }
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
            controller.delegate = self
            controller.categoryId = self.categoryId
        default:
            print("Unknown segue")
            return
        }
    }
}

extension TagLocationViewController: CategoryPickerDelegate {
    func didChooseCategory(withId id: Int) {
        self.categoryId = id
        UpdateLabels()
    }
}
