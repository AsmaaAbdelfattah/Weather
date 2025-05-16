//
//  indicator.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//


import Foundation
import NVActivityIndicatorView
import UIKit
extension NVActivityIndicatorView{
    public func showIndicator(start:Bool){
        self.isHidden = !start
        if start{
            self.type = .ballBeat
            self.color = UIColor(red: 0.51, green: 0.79, blue: 1.00, alpha: 1.00)
            self.startAnimating()
        }else{
            self.stopAnimating()
        }
    }
}

