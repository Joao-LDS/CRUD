//
//  Expense.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 06/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation

struct Entry {
    let uid: String
    var value: Double
    var description: String
    var date: Date?
    var paid_received: Bool
    let type: String
    let useruid: String
    
    init(uid: String, dict: [String: Any]) {
        self.useruid = dict["uid"] as? String ?? ""
        self.uid = uid
        self.value = dict["value"] as? Double ?? 0.0
        self.description = dict["description"] as? String ?? ""
        self.paid_received = dict["paid_received"] as? Bool ?? false
        self.type = dict["type"] as? String ?? ""
        guard let date = dict["date"] as? Double else { return }
        self.date = Date(timeIntervalSince1970: date)
    }
}
