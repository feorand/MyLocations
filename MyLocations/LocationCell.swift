//
//  LocationCell.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 17.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    func configure(for location:Location) {
        descriptionLabel.text = location.locationDescription!.isEmpty ? "(No description)" : location.locationDescription
        addressLabel.text = location.address
    }
}
