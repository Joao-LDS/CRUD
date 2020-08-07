//
//  CustomCell.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 06/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit
import Stevia

class CustomCell: UICollectionViewCell {
    
    private let viewBack = UIView()
    private let valueLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private var entry: Entry?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(expense: Entry) {
        self.entry = expense
        valueLabel.text = "\(expense.value)"
        descriptionLabel.text = "\(expense.description)"
        guard let date = expense.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.string(from: date)
        dateLabel.text = "\(dateFormatter.string(from: date))"
        if expense.type == "expense" {
            valueLabel.textColor = .systemRed
            descriptionLabel.textColor = .systemRed
            dateLabel.textColor = .systemRed
        } else {
            valueLabel.textColor = .systemGreen
            descriptionLabel.textColor = .systemGreen
            dateLabel.textColor = .systemGreen
        }
    }
    
    
}

extension CustomCell: ViewConfiguration {
    func buildView() {
        sv(
            viewBack,
            valueLabel,
            descriptionLabel,
            dateLabel
        )
    }
    
    func addConstraint() {
        viewBack.left(8).right(8).top(8).bottom(8)
        layout(
            18,
            |-18-descriptionLabel,
            "",
            |-18-valueLabel-dateLabel-18-|,
            18
        )
    }
    
    func additionalConfiguration() {
        viewBack.backgroundColor = .white
        viewBack.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewBack.layer.shadowRadius = 5
        viewBack.layer.shadowOpacity = 1
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.cornerRadius = 15
        valueLabel.font = UIFont.boldSystemFont(ofSize: 28)
        valueLabel.textColor = .white
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 28)
        descriptionLabel.textColor = .white
        dateLabel.font = UIFont.boldSystemFont(ofSize: 28)
        dateLabel.textColor = .white
    }
    
}
