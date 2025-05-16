//
//  PaddedTextField.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import UIKit
class PaddedTextField: UITextField {
    
    var padding: UIEdgeInsets

    // Initialize with padding
    override init(frame: CGRect) {
        self.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        super.init(coder: aDecoder)
    }

    // Adjust textRect to include padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    // Adjust placeholderRect to include padding
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
