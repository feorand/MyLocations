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
    var delegate: CategoryPickerDelegate? = nil

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationCategories.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCategory", for: indexPath)
        cell.textLabel?.text = LocationCategories.categories[indexPath.row]
        cell.accessoryType = indexPath.row == categoryId ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didChooseCategory(withId: indexPath.row)
        self.navigationController?.popViewController(animated: true)
    }
}
