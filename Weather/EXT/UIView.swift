//
//  UIView.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import UIKit
extension UIView{
    func dropShadow(corners: CGFloat = 8){
        layer.cornerRadius = corners
        layer.shadowColor = UIColor.systemGray4.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = corners - 1
        clipsToBounds = false
    }
}
