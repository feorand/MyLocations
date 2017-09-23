//
//  CategoryPickerDelegate.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 23.09.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import Foundation

protocol CategoryPickerDelegate {
    func didChooseCategory(withId id: Int)
}
