//
//  AlertViewModel.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 29/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation

protocol AlertViewModelDelegate {
    var text: String? { get }
}

class AlertViewModel {
    
    var delegate: AlertViewModelDelegate?
    
    func resetPassword(_ email: String, completion: @escaping(Error?) -> Void) {
        print(email)
        AuthFirebase().resetPassword(email) { error in
            completion(error)
            if error == nil {
                print("DEBUG: Send email.")
            }
        }
    }
}
