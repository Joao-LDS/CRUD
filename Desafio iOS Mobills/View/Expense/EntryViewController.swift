//
//  ExpenseViewController.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 06/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

enum Type {
    case expense
    case revenue
}

class EntryViewController: UIViewController {
    
    // MARK: - Properties
    
    private var paid_received = true
    private let viewModel = EntryViewModel()
    private let valueTextField = UITextField()
    private let label = UILabel()
    private let topView = UIView()
    private let bottomView = UIView()
    private lazy var valueTextFieldView = TextFieldView(textField: self.valueTextField, placeHolder: "Valor")
    private let descriptionTextField = UITextField()
    private lazy var descriptionTextFieldView = TextFieldView(textField: self.descriptionTextField, placeHolder: "Descrição")
    private let dateTextField = UITextField()
    private lazy var dateTextFieldView = TextFieldView(textField: self.dateTextField, placeHolder: "Data")
    private let datePicker = UIDatePicker()
    private var segmentedControl: UISegmentedControl?
    private let buttonCreate = CustomButtom(title: "Criar", color: #colorLiteral(red: 1, green: 0.7921568627, blue: 0.2274509804, alpha: 1))
    private var date: Int?
    private let closeButton = UIButton()
    private let deleteButton = UIButton()

    // MARK: - View Lifecicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if viewModel.entry != nil {
            setValuesInTextFields()
        }
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(create: Type) {
        self.init()
        switch create {
        case .expense:
            viewModel.type = create
            configureView(type: .expense)
        default:
            viewModel.type = create
            configureView(type: .revenue)
        }
        viewModel.isEdit = false
        deleteButton.isHidden = true
    }
    
    convenience init(edit entry: Entry) {
        self.init()
        self.viewModel.entry = entry
        viewModel.isEdit = true
        if entry.type == "expense" {
            viewModel.type = .expense
        } else {
            viewModel.type = .revenue
        }
        configureView(type: viewModel.type!)
        deleteButton.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions

    private func setValuesInTextFields() {
        valueTextField.text = "\(String(viewModel.value).replacingOccurrences(of: ".", with: ","))"
        descriptionTextField.text = "\(viewModel.description)"
        guard let date = viewModel.date else { return }
        self.date = Int(datePicker.date.timeIntervalSince1970)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = "\(dateFormatter.string(from: date))"
        buttonCreate.setTitle("Alterar", for: .normal)
    }
    
    func configureView(type: Type) {
        switch type {
        case .expense:
            segmentedControl = UISegmentedControl(items: ["Pago", "Não pago"])
            label.text = "Despesa"
            label.textColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.368627451, alpha: 1)
        default:
            segmentedControl = UISegmentedControl(items: ["Recebido", "Não recebido"])
            label.text = "Receita"
            label.textColor = #colorLiteral(red: 0.5411764706, green: 0.7882352941, blue: 0.1490196078, alpha: 1)
        }
        guard let seg = segmentedControl else { return }
        view.sv(seg)
        view.layout(
            dateTextFieldView,
            24,
            seg.centerHorizontally()
        )
        seg.selectedSegmentIndex = 0
        seg.addTarget(self, action: #selector(handleSegmentedControl(_:)), for: .valueChanged)
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDoneDatePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancelDatePicker))
        toolbar.setItems([doneButton, flexibleSpace, cancelButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    // MARK: - Selectors
    
    @objc func handleDoneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.date = Int(datePicker.date.timeIntervalSince1970)
    }
    
    @objc func handleCancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func handleCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDeleteButton() {
        guard let uid = viewModel.entry?.uid else { return }
        self.viewModel.remove(expenseWith: uid)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSegmentedControl(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            paid_received = true
        default:
            paid_received = false
        }
    }
    
    @objc func handleCreate() {
        guard var value = valueTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        guard let date = self.date else { return }
        value = value.replacingOccurrences(of: ",", with: ".")
        var type = ""
        switch viewModel.type {
        case .expense:
            type = "expense"
        default:
            type = "revenue"
        }
        if viewModel.isEdit == true {
            viewModel.update((value as NSString).doubleValue, description, date, paid_received, type: type)
        } else {
            viewModel.create((value as NSString).doubleValue, description, date, paid_received, type: type)
        }
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - ViewConfiguration

extension EntryViewController: ViewConfiguration {
    func buildView() {
        view.sv(
            topView,
            bottomView,
            label,
            closeButton,
            deleteButton,
            valueTextFieldView,
            descriptionTextFieldView,
            dateTextFieldView,
            buttonCreate
        )
    }
    
    func addConstraint() {
        view.layout(
            |-topView.height(<=250).height(30%).top(-20)-|,
            "",
            closeButton.top(7%).left(6%).size(40),
            "",
            deleteButton.top(7%).right(6%).size(40),
            "",
            label.centerHorizontally().top(15%),
            "",
            valueTextFieldView.left(10%).width(80%).width(<=350),
            28,
            descriptionTextFieldView.left(10%).width(80%).width(<=350).centerInContainer(),
            28,
            dateTextFieldView.left(10%).width(80%).width(<=350),
            "",
            |-20-buttonCreate.centerHorizontally().bottom(5%)-20-|,
            "",
            |-bottomView.height(10%).height(<=100).bottom(-20)-|
        )
        
    }
    
    func additionalConfiguration() {
        view.backgroundColor = .white
        topView.addShadow(radius: 8.0)
        topView.backgroundColor = .white
        topView.layer.cornerRadius = 20
        label.font = UIFont.boldSystemFont(ofSize: 32)
        bottomView.backgroundColor = .white
        bottomView.addShadow(radius: 8.0)
        bottomView.layer.cornerRadius = 20
        buttonCreate.setTitle("Criar", for: .normal)
        buttonCreate.addShadow(radius: 4.0)
        buttonCreate.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        closeButton.setImage(#imageLiteral(resourceName: "icon-close"), for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
        deleteButton.setImage(#imageLiteral(resourceName: "icon-delete"), for: .normal)
    }
}
