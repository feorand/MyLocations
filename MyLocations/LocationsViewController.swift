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

    lazy var fetchedResultsController: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()

        let sortDescriptorByDate = NSSortDescriptor(key: "date", ascending: true)
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = fetchedResultsController.object(at: indexPath)
            context.delete(location)

            do {
                try context.save()
            } catch {
                fatalError()
            }
        }
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
                let location = fetchedResultsController.object(at: indexPath)
                controller.locationToEdit = location
            }
        }
    }

    deinit {
        fetchedResultsController.delegate = nil
    }
}

extension LocationsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerWIllChangeContent")
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("insert")
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            print("delete")
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .move:
            print("move")
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            print("update")
            if let cell = tableView.cellForRow(at: indexPath!) as? LocationCell {
                let updatedLocation = fetchedResultsController.object(at: indexPath!)
                cell.configure(for: updatedLocation)
            }
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            print("insert section")
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            print("delete section")
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            print("move section")
        case .update:
            print("update section")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
        tableView.endUpdates()
    }
}
