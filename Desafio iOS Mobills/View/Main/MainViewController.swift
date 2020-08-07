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
    private let topView = UIView()
    private let bottomView = UIView()
    private let nameLabel = UILabel()
    private let totalBalanceLabel = UILabel()
    private let button = UIButton()
    private let revenueButton = CustomButtom(title: "Receita", color: #colorLiteral(red: 0.5411764706, green: 0.7882352941, blue: 0.1490196078, alpha: 1))
    private let expenseButton = CustomButtom(title: "Despesa", color: #colorLiteral(red: 1, green: 0.3490196078, blue: 0.368627451, alpha: 1))
    let viewModel = MainViewModel()
    private let spinner = UIActivityIndicatorView()

    // MARK: - View Lifecicle
    
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
        guard let user = viewModel.user else { return }
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
        totalBalanceLabel.text = "R$ \(viewModel.totalBalance())"
    }
    
    func configureUIWithUser(_ user: User) {
        self.configureActivity(on: false)
        nameLabel.text = "Olá \(user.name)"
    }
    
    func presentLogInView() {
        dismiss(animated: true) {
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: view.frame.height / 8)
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
        let entry = viewModel.entrys[indexPath.row]
        let vc = EntryViewController(edit: entry)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - ViewConfiguration

extension MainViewController: ViewConfiguration {
    func buildView() {
        
        view.sv(
            topView,
            bottomView,
            nameLabel,
            totalBalanceLabel,
            button,
            collection,
            expenseButton,
            revenueButton
        )
    }
    
    func addConstraint() {
        view.layout(
            button.top(8%).left(6%).size(40),
            "",
            nameLabel.top(8%).centerHorizontally().height(40),
            16,
            totalBalanceLabel.centerHorizontally().height(30),
            "",
            |-topView.top(-20)-|.height(<=200) ,
            20,
            |-16-collection-16-|,
            16,
            |-22-expenseButton.bottom(5%).width(40%),
            "",
            revenueButton.bottom(5%).width(40%)-22-|,
            "",
            |-bottomView.height(12%).bottom(-20)-|.height(<=100)
        )
    }
    
    func additionalConfiguration() {
        view.backgroundColor = .white
        topView.addShadow(radius: 8.0)
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 20
        bottomView.backgroundColor = .white
        bottomView.addShadow(radius: 8.0)
        bottomView.layer.cornerRadius = 20
        nameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        totalBalanceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        totalBalanceLabel.font = UIFont.boldSystemFont(ofSize: 28)
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "icon-close"), for: .normal)
        button.imageView?.left(10)
        expenseButton.addTarget(self, action: #selector(handleCreateExpense), for: .touchUpInside)
        expenseButton.title = "Despesa"
        expenseButton.addShadow(radius: 4.0)
        revenueButton.addTarget(self, action: #selector(handleCreateRevenue), for: .touchUpInside)
        revenueButton.title = "Receita"
        revenueButton.addShadow(radius: 4.0)
        spinner.style = .gray
        collection.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .clear
    }
    
}
