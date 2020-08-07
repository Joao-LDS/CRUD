//
//  RevenueService.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 06/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Firebase

class RevenueService {
    
    static let shared = RevenueService()
    
    func uploadRevenue(value: Double, description: String, date: Int, received: Bool, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["uid": uid, "value": value, "description": description, "date": date, "received": received, "type": "revenue"] as [String : Any]
        Database.database().reference().child("revenue").childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetch(completion: @escaping([Expense]) -> Void) {
        var expensives = [Expense]()
        Database.database().reference().child("revenue").observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let expenseID = snapshot.key
            let expense = Expense(uid: expenseID, dict: dict)
            expensives.append(expense)
            completion(expensives)
            print(expensives)
        }
    }
    
    func update(value: Double, description: String, date: Int, received: Bool, uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userid = Auth.auth().currentUser?.uid else { return }
        let values = ["uid": userid, "value": value, "description": description, "date": date, "received": received, "type": "revenue"] as [String : Any]
        Database.database().reference().child("revenue").child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func remove(uid: String) {
        Database.database().reference().child("revenue").child(uid).removeValue()
    }
}
