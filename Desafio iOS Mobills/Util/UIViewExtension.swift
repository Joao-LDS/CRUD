//
//  UIViewExtension.swift
//  Desafio iOS Mobills
//
//  Created by João Luis Santos on 07/08/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit

extension UIView {

    func addShadow(radius: CGFloat) {
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowRadius = radius
        layer.shadowOpacity = 0.7
        layer.shadowOffset = .zero
    }

}
