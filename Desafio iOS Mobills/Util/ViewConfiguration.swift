//
//  ViewConfiguration.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 13/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import Foundation

protocol ViewConfiguration {
    func buildView()
    func addConstraint()
    func additionalConfiguration()
    func setupView()
}

extension ViewConfiguration {
    func setupView() {
        buildView()
        addConstraint()
        additionalConfiguration()
    }
}
