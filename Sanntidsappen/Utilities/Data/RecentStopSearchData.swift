//
// This file is a part of the Sanntidsappen project
//
// Copyright © 2018 the Sanntidsappen authors
// Licensed under Apache License 2.0
//
// See LICENSE.txt for license information
//

import CoreData
import UIKit

class RecentStopSearchData {

    private let appDelegate: AppDelegate

    private let context: NSManagedObjectContext

    private let entity: NSEntityDescription?

    static let shared = RecentStopSearchData()

    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

        entity = NSEntityDescription.entity(forEntityName: "RecentStopSearch", in: context)
    }

    func getRecentSearchFromCoreData(completionHandler: @escaping ([String]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentStopSearch")
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        request.returnsObjectsAsFaults = false

        appDelegate.persistentContainer.performBackgroundTask() { (context) in
            do {
                let result = try context.fetch(request) as! [RecentStopSearch]
                completionHandler(result.map { $0.stop! })
            } catch {
                completionHandler([])
                print("Failed to fetch from Core Data")
            }
        }
    }

    func saveSearchToCoreData(stop: Stop, completionHandler: @escaping ([String]) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentStopSearch")
        let predicate = NSPredicate(format: "stop == %@", stop.properties.name)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false

        appDelegate.persistentContainer.performBackgroundTask() { [unowned self] (context) in
            do {
                let result = try context.fetch(request) as! [RecentStopSearch]

                if result.count == 0 {
                    let newStop = NSManagedObject(entity: self.entity!, insertInto: context)
                    newStop.setValue(stop.properties.name, forKey: "stop")
                    newStop.setValue(Date(), forKey: "dateAdded")

                    try context.save()

                    self.cleanupRecentStopSearchCoreData() { _ in
                        self.getRecentSearchFromCoreData() { completionHandler($0) }
                    }
                }
            } catch {
                print("Failed to fetch from Core Data")
                completionHandler([])
            }
        }
    }

    func cleanupRecentStopSearchCoreData(completionHandler: @escaping (Bool) -> Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentStopSearch")
        request.returnsObjectsAsFaults = false

        appDelegate.persistentContainer.performBackgroundTask() { (context) in
            do {
                let result = (try context.fetch(request) as! [RecentStopSearch])
                var elementsToDelete = 0

                if result.count > 3 {
                    elementsToDelete = result.count - 3

                    for index in 0..<elementsToDelete {
                        context.delete(result[index])
                    }

                    try context.save()
                }
                completionHandler(true)
            } catch {
                print("Failed to fetch from Core Data")
                completionHandler(false)
            }
        }
    }

}
