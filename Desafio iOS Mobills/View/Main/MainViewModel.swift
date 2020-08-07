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
//        EntryService.shared.fetchEntry { expenses in
//            self.expenses = expenses
//            DispatchQueue.main.async {
//                completion(true)
//            }
//        }
    }
}
