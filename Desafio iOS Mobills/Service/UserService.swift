//
//  UserService.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 22/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Firebase

class UserService {
    
    func fetchUser(completion: @escaping (User) -> Void) {
        if Auth.auth().currentUser != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String:AnyObject] else { return }
                let user = User(fromFirebaseWith: uid, dict)
                completion(user)
            }
        }
    }
}
