//
//  AuthService.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 14/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Firebase

class AuthFirebase {
    
    func logUserIn(withEmail email:String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Sucess to log out...")
        } catch let error {
            print("Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func registerUser(_ email: String,_ password: String,_ name: String, completion: @escaping (Error?, DatabaseReference?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error, nil)
                return
            }
            guard let uid = result?.user.uid else { return }
            let values = ["email": email, "name": name]
            REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
            self.sendEmailVerification()
        }
    }
    
    func sendEmailVerification() {
        guard let user = Auth.auth().currentUser else { return }
        user.sendEmailVerification { error in
            if let _ = error {
                return
            }
        }
    }
    
    func resetPassword(_ email: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            completion(error)
        }
    }
    
}
