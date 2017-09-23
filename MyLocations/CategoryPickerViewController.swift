//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 23.09.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {
    
    var categoryId = 0

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationCategories.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCategory", for: indexPath)
        cell.textLabel?.text = LocationCategories.categories[indexPath.row]
        cell.accessoryType = categoryId == indexPath.row ? .checkmark : .none
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        self.categoryId = indexPath.row
    }
}
