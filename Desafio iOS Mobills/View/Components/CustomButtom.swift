//
//  CustomButtom.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 13/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

class CustomButtom: UIButton {

    var title = ""
    var color: UIColor?
    
    init(title: String, color: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)) {
        super.init(frame: .zero)
        self.title = title
        self.color = color
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomButtom: ViewConfiguration {
    func buildView() {}
    
    func addConstraint() {
        height(60)
    }
    
    func additionalConfiguration() {
        setTitle(title, for: .normal)
        backgroundColor = color
        layer.cornerRadius = 18
    }
    
}
