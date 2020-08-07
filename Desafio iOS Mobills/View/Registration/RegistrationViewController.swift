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
    private let mainView = UIView()
    private let mainLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let name = UITextField()
    private let stackView = UIStackView()
    private lazy var emailView = TextFieldView(textField: self.emailTextField, placeHolder: "Email")
    private lazy var passwordView = TextFieldView(textField: self.passwordTextField, placeHolder: "Password", secure: true)
    private lazy var usernameView = TextFieldView(textField: self.name, placeHolder: "Name")
    private let buttonSignUp = CustomButtom(title: "Sign Up", color: #colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1))
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
        view.sv(
            mainView,
            mainLabel,
            usernameView,
            emailView,
            passwordView,
            buttonSignUp,
            alreadyHaveAnAccountButton
        )
    }
    
    func addConstraint() {
        
        view.layout(
            mainView.bottom(10%).right(12).left(12).top(10%),
            "",
            mainLabel.left(10%).top(20%),
            "",
            usernameView.left(10%).right(10%),
            30,
            emailView.left(10%).right(10%).centerInContainer(),
            30,
            passwordView.left(10%).right(10%),
            20,
            buttonSignUp.left(10%).right(10%),
            "",
            alreadyHaveAnAccountButton.bottom(12%).centerHorizontally()
        )
        
    }
    
    func additionalConfiguration() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mainView.layer.cornerRadius = 20
        mainView.addShadow(radius: 8.0)
        mainLabel.text = "Sign Up"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 38)
        emailTextField.keyboardType = .emailAddress
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        buttonSignUp.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        alreadyHaveAnAccountButton.setTitleColor(#colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1), for: .normal)
        alreadyHaveAnAccountButton.setTitle("Already have an account? Log In", for: .normal)
        alreadyHaveAnAccountButton.addTarget(self, action: #selector(handleHaveAnAccount), for: .touchUpInside)
        spinner.style = .whiteLarge
        effectView.effect = UIBlurEffect(style: .dark)
    }
    
    
}
