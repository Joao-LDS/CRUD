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
    
    private var paid_received = true
    private let viewModel = EntryViewModel()
    private let valueLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let valueTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let dateTextField = UITextField()
    private let datePicker = UIDatePicker()
    private var segmentedControl: UISegmentedControl?
    private let button = UIButton(type: .system)
    private var date: Int?
    private let closeButton = UIButton(type: .close)
    private let deleteButton = UIButton(type: .close)
    private var type: Type?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if viewModel.expense != nil {
            setValuesInTextFields()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(create: Type) {
        self.init()
        switch create {
        case .expense:
            print("expense")
            self.type = .expense
            configureWhen(type: .expense)
        default:
            print("revenue")
            self.type = .revenue
            configureWhen(type: .revenue)
        }
    }
    
    convenience init(edit expense: Entry?) {
        self.init()
        self.viewModel.expense = expense
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setValuesInTextFields() {
        valueTextField.text = "\(viewModel.value)"
        descriptionTextField.text = "\(viewModel.description)"
        guard let date = viewModel.date else { return }
        self.date = Int(datePicker.date.timeIntervalSince1970)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateTextField.text = "\(dateFormatter.string(from: date))"
        button.setTitle("Alterar", for: .normal)
    }
    
    func configureWhen(type: Type) {
        switch type {
        case .expense:
            deleteButton.isHidden = true
            segmentedControl = UISegmentedControl(items: ["Pago", "Não pago"])
        default:
            deleteButton.isHidden = true
            segmentedControl = UISegmentedControl(items: ["Recebido", "Não recebido"])
        }
        guard let seg = segmentedControl else { return }
        view.sv(seg)
        view.layout(
            dateTextField,
            18,
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
    
    @objc func handleDoneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        self.date = Int(datePicker.date.timeIntervalSince1970)
//        let date = Date(timeIntervalSince1970: timestamp)
//        print(timestamp)
        print(date!)
    }
    
    @objc func handleCancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func handleCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDeleteButton() {
        guard let uid = viewModel.expense?.uid else { return }
        viewModel.remove(expenseWith: uid)
        handleCloseButton()
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
        switch self.type {
        case .expense:
            type = "expense"
        default:
            type = "revenue"
        }
        if viewModel.expense != nil {
            viewModel.update((value as NSString).doubleValue, description, date, paid_received, type: type)
        } else {
            viewModel.upload((value as NSString).doubleValue, description, date, paid_received, type: type)
        }
        dismiss(animated: true, completion: nil)
    }

}

extension EntryViewController: ViewConfiguration {
    func buildView() {
        view.sv(
            closeButton,
            deleteButton,
            valueLabel,
            valueTextField,
            descriptionLabel,
            descriptionTextField,
            dateLabel,
            dateTextField,
            button
        )
    }
    
    func addConstraint() {
        view.layout(
            closeButton.top(7%).left(6%),
            "",
            deleteButton.top(7%).right(6%),
            "",
            valueLabel.top(15%).left(10%),
            12,
            valueTextField.left(10%).width(80%).height(40),
            22,
            descriptionLabel.left(10%),
            12,
            descriptionTextField.left(10%).width(80%).height(40),
            22,
            dateLabel.left(10%),
            12,
            dateTextField.left(10%).width(80%).height(40),
            "",
            button.centerHorizontally().bottom(8%)
        )
        
    }
    
    func additionalConfiguration() {
        view.backgroundColor = .white
        valueLabel.text = "Valor"
        valueTextField.borderStyle = .line
        descriptionLabel.text = "Descrição"
        descriptionTextField.borderStyle = .line
        dateLabel.text = "Data"
        dateTextField.borderStyle = .line
        button.setTitle("Criar", for: .normal)
        button.addTarget(self, action: #selector(handleCreate), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(handleDeleteButton), for: .touchUpInside)
    }
}
