//
//  MainViewController.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 18/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

class MainViewController: UIViewController {
    
    // MARK: - Properties
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    private let nameLabel = UILabel()
    private let button = UIButton(type: .close)
    private let revenueButton = CustomButtom(title: "Receita")
    private let createExpenseButton = CustomButtom(title: "Despesa")
    let viewModel = MainViewModel()
    private let spinner = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        self.configureActivity(on: true)
        collection.delegate = self
        collection.dataSource = self
        viewModel.authenticateUser { sucess in
            if sucess {
                self.viewModel.fetchUser()
                self.setupView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let user = viewModel.user else {
            print("Deu merda de novo.")
            return
        }
        self.viewModel.fetchEntry(forUser: user)
    }
    
    // MARK: - Functions
    
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
    
    // MARK: - Selectors
    
    @objc func handleButton() {
        viewModel.logoutUser()
    }
    
    @objc func handleCreateExpense() {
        let vc = EntryViewController(create: .expense)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleCreateRevenue() {
        let vc = EntryViewController(create: .revenue)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


// MARK: - MainViewModelDelegate

extension MainViewController: MainViewModelDelegate {
    func reloadCollection() {
        self.collection.reloadData()
    }
    
    func configureUIWithUser(_ user: User) {
        self.configureActivity(on: false)
        nameLabel.text = "\(user.name)"
    }
    
    func presentLogInView() {
        dismiss(animated: true) {
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: view.frame.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.entrys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        let expense = viewModel.entrys[indexPath.row]
        cell.configureCell(expense: expense)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expense = viewModel.entrys[indexPath.row]
        print(expense)
        let vc = EntryViewController(edit: expense)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - ViewConfiguration

extension MainViewController: ViewConfiguration {
    func buildView() {
        
        view.sv(
            nameLabel,
            button,
            collection,
            createExpenseButton,
            revenueButton
        )
    }
    
    func addConstraint() {
        view.layout(
            button.top(8%).left(6%),
            "",
            nameLabel.top(8%).centerHorizontally(),
            40,
            |-16-collection-16-|,
            16,
            |-16-createExpenseButton.bottom(5%).width(40%),
            "",
            revenueButton.bottom(5%).width(40%)-16-|
        )
    }
    
    func additionalConfiguration() {
        view.backgroundColor = .white
        nameLabel.textColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        createExpenseButton.addTarget(self, action: #selector(handleCreateExpense), for: .touchUpInside)
        revenueButton.addTarget(self, action: #selector(handleCreateRevenue), for: .touchUpInside)
        spinner.style = .medium
        collection.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
    }
    
}
