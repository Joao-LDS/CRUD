//
//  User.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 22/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation

struct User {
    let email: String
    let name: String
    let uid: String
    
    init(fromFirebaseWith uid: String,_ dictionary: [String:AnyObject]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
    }
    
    init(fromGoogleWith email: String,_ fullname: String,_ givenName: String) {
        self.email = email
        self.name = givenName
        self.uid = ""
    }
}
