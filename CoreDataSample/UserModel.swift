//
//  UserModel.swift
//  CoreDataSample
//
//  Created by Santhosh on 24/01/22.
//

import Foundation

struct UserModel {
    init() {
        
    }
    var name: String?
    var email: String?
    var password: String?
    var address: AddressModel?
}


struct AddressModel {
    init() {
    }
    var city: String?
    var country: String?
}
