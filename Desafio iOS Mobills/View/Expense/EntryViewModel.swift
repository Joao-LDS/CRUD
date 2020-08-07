//
//  ExpenseViewModel.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 06/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation

class EntryViewModel {
    
    var expense: Entry?
    var value: Double { get { return expense?.value ?? 0 } }
    var description: String { get { return expense?.description ?? "" } }
    var date: Date? { get { return expense?.date ?? nil } }
    
    func upload(_ value: Double,_ description: String,_ date: Int,_ paid_received: Bool, type: String) {
        EntryService.shared.uploadEntry(value: value, description: description, date: date, paid_received: paid_received, type: type) { error, reference in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            print("DEBUG: Expense registered succesfully.")
        }
    }
    
    func update(_ value: Double,_ description: String,_ date: Int,_ paid_received: Bool, type: String) {
        guard let uid = expense?.uid else { return }
        EntryService.shared.updateEntry(value: value, description: description, date: date, paid_received: paid_received, type: type, uid: uid) { error, reference in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func remove(expenseWith uid: String) {
        EntryService.shared.removeEntry(uid: uid)
    }
    
}
