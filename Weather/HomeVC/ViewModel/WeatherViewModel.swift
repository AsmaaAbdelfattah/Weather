//
//  WeatherViewModel.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//
import RxSwift
import Foundation
protocol WeatherViewModelProtocol {
    var weather: WeatherResponse! { get set }
    var bindWeather: (()->()) { get set }
    var bindWeatherForcast: (()->()) { get set }
    var weatherForcast: WeatherForcast! { get set }
    var error: PublishSubject<String> { get set }
    
    func getCurrentWeather(url:String, params:[String: Any])
    func getForcast(url:String, params:[String: Any])
}
class WeatherViewModel{
    
    //MARK: vars
    let networkManager = NetworkService.getInstance()
    var weather: WeatherResponse!{
        didSet{
            bindWeather()
        }
    }
    var bindWeather: (()->()) = {}
    var weatherForcast: WeatherForcast!{
        didSet{
            bindWeatherForcast()
        }
    }
    var bindWeatherForcast: (()->()) = {}
    
    var error = PublishSubject<String>()
    
    //MARK: functions
    func getCurrentWeather(url:String, params:[String: Any]){
        networkManager.getData(url: url, parms: params) { [weak self] (result: Result<WeatherResponse,Error>) in
            switch result {
            case .success(let success):
                print(success)
                if let code =  success.cod, code == 200 {
                    self?.weather = success
                }else if let mess = success.message{
                   self?.error.onNext(mess)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getForcast(url:String, params:[String: Any]) {
        networkManager.getData(url: url, parms: params) { [weak self] (result: Result<WeatherForcast,Error>) in
            switch result {
            case .success(let success):
                print(success)
                if success.cod == "200" {
                    self?.weatherForcast = success
                }else {
                 //   self?.error.onNext(success.m)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
  
    
}
