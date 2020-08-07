//
//  TextFieldView.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 13/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

class TextFieldView: UIView {
    
    // MARK: - Properties
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        return tf
    }()
    private var placeHolder = ""
    private var secure = false
    
    // MARK: - Init
    
    init(textField: UITextField, placeHolder: String, secure: Bool = false) {
        super.init(frame: .zero)
        self.textField = textField
        self.placeHolder = placeHolder
        self.secure = secure
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ViewConfiguration

extension TextFieldView: ViewConfiguration {
    func buildView() {
        sv(
            textField
        )
    }
    
    func addConstraint() {
        height(60)
        layout(
            |-textField-|.centerVertically()
        )
    }
    
    func additionalConfiguration() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        layer.cornerRadius = 8
        addShadow(radius: 4.0)
        textField.placeholder = placeHolder
        let color = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        textField.textColor = color
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: color])
        textField.isSecureTextEntry = secure
        textField.autocapitalizationType = .none
    }
    
}
