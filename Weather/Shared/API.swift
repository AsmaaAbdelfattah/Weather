//
//  API.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import Foundation
enum Networking{
    
    private var baseURL: String { return  UserDefaults.standard.getBase()}
    
    case image(iconName: String)
    case weather
    case forecast
}
extension Networking{

    var fullPath :String {
        var endPoint: String
        switch self {
            
            //MARK: account
        case .weather:
            endPoint = "data/2.5/weather"
        case .image(let iconName):
            endPoint = "img/wn/\(iconName)@2x.png"
        case .forecast:
            endPoint = "data/2.5/forecast"
        }
        return baseURL + endPoint
    }
}
