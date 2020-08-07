//
//  Animation.swift
//  LoginFirebase
//
//  Created by João Luis Santos on 28/07/20.
//  Copyright © 2020 João Luis Santos. All rights reserved.
//

import UIKit

class Animation {
    func animationToPresent(view: UIView) {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }
    
    func animationToDismiss(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            view.removeFromSuperview()
        }
    }
}
