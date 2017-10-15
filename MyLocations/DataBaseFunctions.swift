//
//  DataBaseFunctions.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 15.10.2017.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func fatalErrorWithNotification(error:Error) {
        let notificationName = Notification.Name(rawValue: "NSManagedObjectContextFatalError")
        print("Fatal error: \(error)")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
}
