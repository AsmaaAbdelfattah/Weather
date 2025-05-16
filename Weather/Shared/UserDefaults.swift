//
//  UserDefaults.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import Foundation
enum UserDefaultsKeys:String{
    case baseURL

    
}
extension UserDefaults{
    
    func setBase(value: String){
        setValue(value, forKey: UserDefaultsKeys.baseURL.rawValue)
    }
    func getBase() -> String{
        return string(forKey: UserDefaultsKeys.baseURL.rawValue) ?? ""
    }
    func saveForecastsToUserDefaults(_ forecasts: [WeatherList]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(forecasts) {
            UserDefaults.standard.set(encoded, forKey: "savedForecasts")
        }
    }
    func loadForecastsFromUserDefaults() -> [WeatherList] {
        if let savedData = UserDefaults.standard.data(forKey: "savedForecasts") {
            let decoder = JSONDecoder()
            if let savedForecasts = try? decoder.decode([WeatherList].self, from: savedData) {
                return savedForecasts
            }
        }
        return []
    }
}
