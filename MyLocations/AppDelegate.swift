//
//  AppDelegate.swift
//  MyLocations
//
//  Created by Pavel Prokofyev on 25.05.17.
//  Copyright © 2017 Pavel Prokofyev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error in loading data model \(error)")
            }
        }
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    func registerNotificationObserverForCoreDataSavingError() {
        func findPresentedViewController() -> UIViewController {
            let rootViewController = self.window!.rootViewController!
            return rootViewController.presentedViewController ?? rootViewController
        }
        
        let observerHandler: (Notification) -> Void = {_ in
            let alert = UIAlertController(title: "Error", message: "An error occured. Sorry", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { action in
                NSException(name: .internalInconsistencyException, reason: "Fatal Core Data exception", userInfo: nil).raise()
            }
            
            alert.addAction(okAction)
            
            let controller = findPresentedViewController()
            controller.present(alert, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(forName: CoreDataNotification.saveError.value, object: nil, queue: OperationQueue.main, using: observerHandler)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        registerNotificationObserverForCoreDataSavingError()

        let tabController = window!.rootViewController as! UITabBarController
        let currentLocationController = tabController.viewControllers![0] as! CurrentLocationViewController
        currentLocationController.context = self.context

        let locationsNavigationController = tabController.viewControllers![1] as! UINavigationController
        let locationsController = locationsNavigationController.topViewController as! LocationsViewController
        locationsController.context = self.context
        
        return true
    }

}

