//
//  DBCommon.swift
//  CoreDataSample
//
//  Created by Santhosh on 24/01/22.
//

import Foundation
import CoreData
class DBCommon {
    ////// Save User Data
    class func saveUserData(user: UserModel, onSuccess: @escaping (User?) -> Void) {
        self.getUserData(name: user.name, onFetch: { userData in
            var userObject = userData
            if userObject == nil {
                userObject = DBManager.shared.getManagedObject(for: TableNames.User) as? User
            }
            if let userData = userObject {
                userData.name = user.name
                userData.email = user.email
                userData.password = user.password
                if let address = DBManager.shared.getManagedObject(for: TableNames.Address) as? Address {
                    address.city = user.address?.city
                    address.country = user.address?.country
                }
            }
            onSuccess(userObject)
        })
    }
    
   private class func getUserData(name: String?, onFetch: @escaping (User?) -> Void) {
        if let moc = DBManager.shared.getManagedObjectContext() {
            if let name = name {
                let fetchRequest = NSFetchRequest<User>(entityName: TableNames.User)
                fetchRequest.predicate = NSPredicate.init(format: "name == %@", name)
                do {
                    let result: [User] =  try moc.fetch(fetchRequest)
                    let user = result.isEmpty ? nil : result.first
                    onFetch(user)
                } catch let error as NSError {
                    print(error)
                }
            }
        }
    }
 
}
