//
//  DBModel.swift
//  CoreDataSample
//
//  Created by Santhosh on 24/01/22.
//

import Foundation

class DBModel {
    
    class func saveUser(user: UserModel) {
        DBCommon.saveUserData(user: user, onSuccess: { user in
            guard let _ = user else {
                return
            }
            DBManager.shared.save()
        })
    }
}
