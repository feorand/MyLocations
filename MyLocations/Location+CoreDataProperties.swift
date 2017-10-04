//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 04.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var date: Date
    @NSManaged public var locationDescription: String?
    @NSManaged public var address: String?
    @NSManaged public var category: Int16

}
