//
//  RegistrationViewModel.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 14/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Firebase

protocol RegistrationViewModelDelegate {
    func showAlert(title: String, message: String)
    func configureBlurEffect(on: Bool)
}

struct RegistrationViewModel {
    
    var delegate: RegistrationViewModelDelegate?
    
    func registerUser(_ email: String,_ password: String,_ name: String) {
        AuthFirebase().registerUser(email, password, name) { error, ref in
            if let error = error {
                self.delegate?.configureBlurEffect(on: false)
                self.delegate?.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            print("Sign up sucessful")
            self.delegate?.configureBlurEffect(on: false)
            self.delegate?.showAlert(title: "Congratulations", message: "Sucessful registration! Verify your email.")
        }
    }
}
