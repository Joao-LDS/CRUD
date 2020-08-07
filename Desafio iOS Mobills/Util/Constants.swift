//
//  Constants.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 14/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation
import Firebase

let STORAGE_REF =  Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_ENTRYS = DB_REF.child("entrys")
let REF_USER_ENTRYS = DB_REF.child("user-entrys")
