//
//  LocationsViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 17.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class LocationsViewController: UITableViewController {

    weak var context: NSManagedObjectContext!
    var locations: [Location] = []

    lazy var fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()

        let sortDescriptorByDate = NSSortDescriptor(key: "Date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptorByDate]

        fetchRequest.fetchBatchSize = 20

        let controller = NSFetchedResultsController<Location>(
                fetchRequest: fetchRequest,
                managedObjectContext: self.context,
                sectionNameKeyPath: nil,
                cacheName: "Locations")

        controller.delegate = self

        return controller
    }()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        let count = sectionInfo.numberOfObjects
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.configure(for: fetchedResultsController.object(at: indexPath))
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        performFetch()
    }

    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditLocation" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController! as! TagLocationViewController
            controller.context = self.context

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let location = locations[indexPath.row]
                controller.locationToEdit = location
            }
        }
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}

extension LocationsViewController: NSFetchedResultsControllerDelegate {

}
