//
//  ExpenseService.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 06/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Firebase

class EntryService {
    
    static let shared = EntryService()
    
    func uploadEntry(value: Double, description: String, date: Int, paid_received: Bool, type: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["uid": uid, "value": value, "description": description, "date": date, "paid_received": paid_received, "type": type] as [String : Any]
        let ref = REF_ENTRYS.childByAutoId()
        ref.updateChildValues(values) { error, reference in
            guard let entryID = ref.key else { return }
            REF_USER_ENTRYS.child(uid).updateChildValues([entryID: 1], withCompletionBlock: completion)
        }
    }
    
    func fetchEntry(completion: @escaping([Entry]) -> Void) {
        var expensives = [Entry]()
        DB_REF.child("entrys").observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let expenseID = snapshot.key
            let expense = Entry(uid: expenseID, dict: dict)
            expensives.append(expense)
            completion(expensives)
            print(expensives)
        }
    }
    
    func updateEntry(value: Double, description: String, date: Int, paid_received: Bool, type: String, uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userid = Auth.auth().currentUser?.uid else { return }
        let values = ["uid": userid, "value": value, "description": description, "date": date, "paid_received": paid_received, "type": type] as [String : Any]
        DB_REF.child("entrys").child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func removeEntry(uid: String) {
        DB_REF.child("entrys").child(uid).removeValue()
    }
    
    func fetchEntrys(forUser user: User, completion: @escaping([Entry]) -> Void) {
        var entrys = [Entry]()
        REF_USER_ENTRYS.child(user.uid).observe(.childAdded) { snapshot in
            let entryID = snapshot.key
            REF_ENTRYS.child(entryID).observeSingleEvent(of: .value) { snapshot in
                print(snapshot)
                guard let dict = snapshot.value as? [String: Any] else { return }
                let entry = Entry(uid: entryID, dict: dict)
                entrys.append(entry)
                print(entrys)
                completion(entrys)
            }
        }
    }
}
