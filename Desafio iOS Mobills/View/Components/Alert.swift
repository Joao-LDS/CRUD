//
//  Alert.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 21/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

class Alert: UIView {
    
    // MARK: - Properties
    
    let viewModel = AlertViewModel()
    private let labelTitle = UILabel()
    private let labelMessage = UILabel()
    private let line = UIView()
    private let tf =  UITextField()
    private let okButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureShowAlert(view: UIView, title: String, message: String) {
        view.sv(self)
        labelTitle.text = title
        labelMessage.text = message
        labelMessage.numberOfLines = 0
        centerInContainer().height(200).width(75%)
        Width <= 300
        layout(
            16,
            labelTitle.centerHorizontally(),
            16,
            |-8-labelMessage-8-|,
            "",
            |-line.height(1)-|,
            |-okButton.height(50)-|,
            0
        )
        okButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        Animation().animationToPresent(view: self)
    }
    
    func configureShowAlertWithTextField(view: UIView, title: String, message: String) {
        view.sv(self)
        self.sv(tf, cancelButton)
        labelTitle.text = title
        labelMessage.text = message
        |-22-centerInContainer().width(<=300).height(200)-22-|
        layout(
            16,
            labelTitle.centerHorizontally(),
            16,
            |-8-labelMessage-8-|,
            "",
            |-8-tf.height(30)-8-|,
            16,
            |-line.height(1)-|,
            |-okButton.width(50%).height(50)-cancelButton.width(50%)-|.height(50),
            0
        )
        labelMessage.numberOfLines = 0
        okButton.addTarget(self, action: #selector(dismissWhenTextField), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        Animation().animationToPresent(view: self)
    }
    
    // MARK: - Selectors
    
    @objc func dismiss() {
        Animation().animationToDismiss(view: self)
    }
    
    @objc func dismissWhenTextField() {
        if let email = tf.text {
            viewModel.resetPassword(email) { error in
                if error != nil {
                    self.labelMessage.text = error?.localizedDescription
                    return
                } else {
                    self.dismiss()
                }
            }
        }
    }
    
}

// MARK: - ViewConfiguration

extension Alert: ViewConfiguration {
    func buildView() {
        sv(
            labelTitle,
            labelMessage,
            line,
            okButton
        )
    }
    
    func addConstraint() {}
    
    func additionalConfiguration() {
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        addShadow(radius: 4.0)
        layer.cornerRadius = 10
        labelTitle.textColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        labelTitle.font = UIFont.boldSystemFont(ofSize: 18)
        labelMessage.textAlignment = .center
        labelMessage.textColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        line.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        okButton.setTitle("OK", for: .normal)
        okButton.tintColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.tintColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        tf.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tf.autocapitalizationType = .none
        tf.layer.cornerRadius = 4
        tf.layer.borderColor = #colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1)
        tf.layer.borderWidth = 1
        tf.placeholder = "Email"
        tf.textAlignment = .center
    }
    
    
}
