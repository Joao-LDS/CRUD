//
//  LoginViewController.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 13/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = LoginViewModel()
    private let mainView = UIView()
    private let mainLabel = UILabel()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private lazy var emailView = TextFieldView(textField: self.emailTextField, placeHolder: "Email")
    private lazy var passwordView = TextFieldView(textField: self.passwordTextField, placeHolder: "Password", secure: true)
    private let forgotPassword = UIButton()
    private let dontHaveAnAccountButton = UIButton()
    private let signInButton = CustomButtom(title: "Sign In", color: #colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1))
    private let alert = Alert()
    

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setupView()
    }
    
    // MARK: - Selectors
    
    @objc func handleDontHaveAnAccountButton() {
        let vc = RegistrationViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleSignIn() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        viewModel.logUserIn(withEmail: email, password: password)
    }
    
    @objc func handleForgotPassword() {
        let alert = Alert()
        alert.configureShowAlertWithTextField(view: self.view, title: "Forgot password?", message: "Enter your account email:")
    }
    
}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func presentMainView() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        alert.configureShowAlert(view: self.view, title: title, message: message)
    }
}

// MARK: - ViewConfiguration

extension LoginViewController: ViewConfiguration {
    func buildView() {
        view.sv(
            mainView,
            mainLabel,
            emailView,
            passwordView,
            forgotPassword,
            signInButton,
            dontHaveAnAccountButton
        )
    }
    
    func addConstraint() {
        view.layout(
            mainView.bottom(10%).right(12).left(12).top(10%),
            "",
            mainLabel.left(10%).top(20%),
            "",
            emailView.left(10%).right(10%),
            30,
            passwordView.centerInContainer().left(10%).right(10%),
            10,
            forgotPassword.right(10%).height(20),
            20,
            signInButton.left(10%).right(10%),
            "",
            dontHaveAnAccountButton.centerHorizontally().bottom(15%)
        )
    }
    
    func additionalConfiguration() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        mainView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mainView.layer.cornerRadius = 20
        mainView.addShadow(radius: 8.0)
        mainLabel.text = "Sign In"
        mainLabel.font = UIFont.boldSystemFont(ofSize: 38)
        emailTextField.keyboardType = .emailAddress
        signInButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        forgotPassword.setTitle("Forgot password?", for: .normal)
        forgotPassword.setTitleColor(#colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1), for: .normal)
        forgotPassword.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        dontHaveAnAccountButton.setTitle("Or sign In", for: .normal)
        dontHaveAnAccountButton.setTitleColor(#colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1), for: .normal)
        dontHaveAnAccountButton.addTarget(self, action: #selector(handleDontHaveAnAccountButton), for: .touchUpInside)
        
    }
    
    
}
