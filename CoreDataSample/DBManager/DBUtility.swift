//
//  DBUtility.swift
//  CoreDataSample
//
//  Created by Santhosh on 24/01/22.
//

import Foundation
import CoreData

class DBUtility {
    class func getAllUserData() -> [User]? {
        if let moc = DBManager.shared.getManagedObjectContext() {
            let fetchRequest = NSFetchRequest<User>(entityName: TableNames.User)
            do {
                let result: [User] =  try moc.fetch(fetchRequest)
                return result
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
}


extension DBUtility {
    class func deleteUserWithName(name: String?, onDelete: @escaping (NSPersistentStoreResult) -> Void) {
        guard let name = name else { return  }
        if let moc = DBManager.shared.getManagedObjectContext() {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TableNames.User)
            let predicate = NSPredicate(format: "name == %@", name)
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate])
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                let success = try moc.execute(deleteRequest)
                onDelete(success)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}
