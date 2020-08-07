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

    private var title = ""
    
    init(title: String) {
        super.init(frame: .zero)
        self.title = title
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
        backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.3647058824, blue: 0.8980392157, alpha: 1)
        layer.cornerRadius = 18
    }
    
}
