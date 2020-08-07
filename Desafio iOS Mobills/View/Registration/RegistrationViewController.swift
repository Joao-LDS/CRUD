//
//  RegistrationViewController.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 13/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia
import Firebase

class RegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private let viewBottom = UIView()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let name = UITextField()
    private let stackView = UIStackView()
    private lazy var emailView = TextFieldView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: self.emailTextField, placeHolder: "Email")
    private lazy var passwordView = TextFieldView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: self.passwordTextField, placeHolder: "Password", secure: true)
    private lazy var usernameView = TextFieldView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: self.name, placeHolder: "Name")
    private let buttonSignUp: UIButton = CustomButtom(title: "Sign Up")
    private let alreadyHaveAnAccountButton = UIButton()
    private let effectView = UIVisualEffectView()
    private let spinner = UIActivityIndicatorView()
    private let alert = Alert()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupView()
    }
    
    // MARK: - Functions
    
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = name.text else { return }
        configureBlurEffect(on: true)
        viewModel.registerUser(email, password, name)
    }
    
    @objc func handleHaveAnAccount() {
        dismiss(animated: true, completion: nil)
    }
    
}
// MARK: - RegistrationViewModelDelegate

extension RegistrationViewController: RegistrationViewModelDelegate {
    func showAlert(title: String, message: String) {
        alert.configureShowAlert(view: self.view, title: title, message: message)
    }
    
    func configureActivity(on: Bool) {
        if on {
            spinner.startAnimating()
            view.sv(spinner)
            spinner.centerInContainer()
        } else {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
    
    func configureBlurEffect(on: Bool) {
        if on {
            view.sv(effectView)
            effectView.fillContainer()
            Animation().animationToPresent(view: effectView)
            configureActivity(on: true)
        } else {
            configureActivity(on: false)
            Animation().animationToDismiss(view: effectView)
        }
    }
}

// MARK: - ViewConfiguration

extension RegistrationViewController: ViewConfiguration {
    func buildView() {
        stackView.addArrangedSubview(emailView)
        stackView.addArrangedSubview(passwordView)
        stackView.addArrangedSubview(usernameView)
        stackView.addArrangedSubview(buttonSignUp)
        view.sv(
            viewBottom,
            stackView,
            alreadyHaveAnAccountButton
        )
    }
    
    func addConstraint() {
        
        view.layout(
            |-26-stackView.width(<=300).centerVertically(30).centerHorizontally()-26-|,
            "",
            viewBottom.bottom(-10).right(0).left(0).height(20%),
//            alreadyHaveAnAccountButton.bottom(8%).centerHorizontally()
            alignCenter(alreadyHaveAnAccountButton, with: viewBottom)
        )
        
    }
    
    func additionalConfiguration() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        viewBottom.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.3647058824, blue: 0.8980392157, alpha: 1)
        viewBottom.layer.cornerRadius = 20
        viewBottom.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewBottom.layer.shadowRadius = 8.0
        viewBottom.layer.shadowOpacity = 0.7
        viewBottom.layer.shadowOffset = .zero
        emailTextField.keyboardType = .emailAddress
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        buttonSignUp.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        alreadyHaveAnAccountButton.setTitle("Already have an account? Log In", for: .normal)
        alreadyHaveAnAccountButton.addTarget(self, action: #selector(handleHaveAnAccount), for: .touchUpInside)
        spinner.style = .whiteLarge
        effectView.effect = UIBlurEffect(style: .dark)
    }
    
    
}
