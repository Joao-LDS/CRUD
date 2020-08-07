//
//  LoginViewModel.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 20/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation

protocol LoginViewModelDelegate {
    func presentMainView()
    func showAlert(title: String, message: String)
}

class LoginViewModel {
    
    var delegate: LoginViewModelDelegate?
    let auth = AuthFirebase()
    
    func logUserIn(withEmail email: String, password: String) {
        auth.logUserIn(withEmail: email, password: password) { result, error in
            if result?.user.isEmailVerified == false {
                self.delegate?.showAlert(title: "Error", message: "Your email is not verified.")
                self.auth.signOut()
                return
            } else if let error = error {
                print("ERROR: \(error.localizedDescription)")
                self.delegate?.showAlert(title: "Error", message: error.localizedDescription)
                self.auth.signOut()
                return
            }
            self.delegate?.presentMainView()
        }
    }
}
