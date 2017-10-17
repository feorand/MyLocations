//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 17.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreData

class LocationsViewController: UITableViewController {

    weak var context: NSManagedObjectContext!
    var locations: [Location] = []

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell

        let index = indexPath.row
        cell.addressLabel.text = locations[index].address
        cell.descriptionLabel.text = locations[index].locationDescription
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let fetchRequest = NSFetchRequest<Location>()
        let entity = Location.entity()
        fetchRequest.entity = entity

        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            locations = try context.fetch(fetchRequest)
        } catch {
            fatalError()
        }
    }
}
