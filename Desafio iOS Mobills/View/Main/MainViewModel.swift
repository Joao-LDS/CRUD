//
//  MainViewModel.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 18/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Firebase

protocol MainViewModelDelegate {
    func presentLogInView()
    func configureUIWithUser(_ user: User)
    func reloadCollection()
}

class MainViewModel {
    
    static let shared = MainViewModel()
    var delegate: MainViewModelDelegate?
    var user: User? {
        didSet {
            guard let user = user else { return }
            delegate?.configureUIWithUser(user)
        }
    }
    var entrys: [Entry] = []
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        if Auth.auth().currentUser == nil {
            print("User is not logged in...")
            DispatchQueue.main.async {
                self.delegate?.presentLogInView()
            }
        } else {
            completion(true)
        }
    }
    
    func logoutUser() {
        AuthFirebase().signOut()
        if Auth.auth().currentUser == nil {
            delegate?.presentLogInView()
        }
    }
    
    func fetchUser() {
        UserService().fetchUser { user in
            self.user = user
            self.fetchEntry(forUser: user)
        }
    }
    
    func fetchEntry(forUser user: User) {
        EntryService.shared.fetchEntrys(forUser: user) { entrys in
            self.entrys = entrys
            self.delegate?.reloadCollection()
        }
        DispatchQueue.main.async {
            self.delegate?.reloadCollection()
        }
        
    }
    
    func totalBalance() -> String {
        var totalBalance = 0.0
        for entry in entrys {
            if entry.type == "revenue" {
                totalBalance += entry.value
            } else {
                totalBalance -= entry.value
            }
        }
        let total = String(totalBalance).replacingOccurrences(of: ".", with: ",")
        return total
    }
}
