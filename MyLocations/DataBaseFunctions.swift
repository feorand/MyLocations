//
//  DataBaseFunctions.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 15.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataNotification: String {
    case saveError = "NSManagedObjectContextSaveFatalError"
    
    var value: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

extension NSManagedObjectContext {
    func raiseNotificationFor(error:Error) {
        let notificationName = CoreDataNotification.saveError.value
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
