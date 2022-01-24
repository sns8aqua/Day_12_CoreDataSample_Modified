//
//  DBManager.swift
//  CoreDataSample
//
//  Created by Santhosh on 24/01/22.
//

import Foundation
import CoreData
import UIKit

class DBManager {
    enum CoreDataSaveResult {
        case success
        case failure(NSError)
        public func error() -> NSError? {
            if case .failure(let error) = self {
                return error
            }
            return nil
        }
    }
    
    static let shared: DBManager = DBManager()
    func getManagedObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        let manageContext = appDelegate.persistentContainer.viewContext
        return manageContext
    }
    func getEntityDetails(tableName: String, context: NSManagedObjectContext) -> NSEntityDescription? {
        guard let entity = NSEntityDescription.entity(forEntityName: tableName, in: context) else {return nil}
        return entity
    }
    func getManagedObject(for entity: String) -> NSManagedObject? {
        if let moc = self.getManagedObjectContext() {
        guard let entity = NSEntityDescription.entity(forEntityName: entity, in: moc) else {return nil}
            return NSManagedObject.init(entity: entity, insertInto: moc)
        }
        return nil
    }
    func save(completion: ((CoreDataSaveResult) -> Void)? = nil) {
        if let moc = self.getManagedObjectContext() {
            let block = {
                if moc.hasChanges {
                    do {
                        try moc.save()
                        completion?(CoreDataSaveResult.success)
                    } catch let error as NSError {
                        let nsError = error as NSError
                        completion?(CoreDataSaveResult.failure(nsError))
                    }
                }
            }
            moc.perform(block)
        }
    }
}


