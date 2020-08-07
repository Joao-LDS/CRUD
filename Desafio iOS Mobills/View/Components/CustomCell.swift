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
    
    // MARK: - Properties
    
    private let viewBack = UIView()
    private let valueLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let iconView = UIImageView()
    private var imageIcon: UIImage?
    private var entry: Entry?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func configureCell(expense: Entry) {
        self.entry = expense
        let value = String(expense.value).replacingOccurrences(of: ".", with: ",")
        valueLabel.text = "R$ \(value)"
        descriptionLabel.text = "\(expense.description)"
        guard let date = expense.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.string(from: date)
        dateLabel.text = "\(dateFormatter.string(from: date))"
        if expense.type == "expense" {
            imageIcon = #imageLiteral(resourceName: "icon-down")
            iconView.image = imageIcon
            iconView.backgroundColor = #colorLiteral(red: 1, green: 0.3490196078, blue: 0.368627451, alpha: 1)
        } else {
            imageIcon = #imageLiteral(resourceName: "icon-up")
            iconView.image = imageIcon
            iconView.backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.7882352941, blue: 0.1490196078, alpha: 1)
        }
    }
    
    
}

// MARK: - ViewConfiguration

extension CustomCell: ViewConfiguration {
    func buildView() {
        sv(
            viewBack,
            valueLabel,
            descriptionLabel,
            iconView
        )
    }
    
    func addConstraint() {
        layout(
            viewBack.left(25).right(8).top(8).bottom(8),
            "",
            iconView.centerVertically().left(0).size(50)-18-descriptionLabel-valueLabel.centerVertically()-26-|
        )
    }
    
    func additionalConfiguration() {
        viewBack.backgroundColor = .white
        viewBack.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewBack.layer.shadowRadius = 5
        viewBack.layer.shadowOpacity = 0.6
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.cornerRadius = 15
        iconView.layer.cornerRadius = 25
        valueLabel.font = UIFont.systemFont(ofSize: 22)
        valueLabel.textColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        descriptionLabel.font = UIFont.systemFont(ofSize: 22)
        descriptionLabel.textColor = #colorLiteral(red: 0.6784313725, green: 0.7098039216, blue: 0.7411764706, alpha: 1)
        dateLabel.font = UIFont.boldSystemFont(ofSize: 28)
    }
    
}
