//
//  UIImage.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import UIKit
import Kingfisher
extension UIImageView {
    func setImage(img:String){
        self.kf.indicatorType = .activity
        let  placeholderImage = UIImage(named: "placeholder")
        self.kf.setImage(
            with:URL(string: img),
            placeholder: placeholderImage,
            options: nil,
            progressBlock: nil
        ) {[weak self] result in
            switch result {
            case .success(let value):
                print("Image loaded successfully: \(value.source.url?.absoluteString ?? "")")
                self?.contentMode = .redraw
            case .failure(let error):
                print("Image failed to load: \(error.localizedDescription)")
                self?.contentMode = .scaleAspectFit
                self?.image = placeholderImage // Set the placeholder on failure
            }
        }
    }
}
