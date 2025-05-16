//
//  WeatherTVCell.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import UIKit

class WeatherTVCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!{
        didSet{
            cardView.dropShadow()
        }
    }
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var day: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func injectCell(iconName:String, temp:String, date:String){
        icon.setImage(img:  Networking.image(iconName: iconName).fullPath)
        tempLbl.text = temp
        day.text = date.isEmpty ? "Today" : getDate(date: date)
    }
    
    //MARK: extrcar only date
    func getDate(date: String) -> String {
        if let spaceIndex = date.firstIndex(of: " ") {
            let dateOnly = String(date[..<spaceIndex])
           return dateOnly
        }
        return ""
    }
}
