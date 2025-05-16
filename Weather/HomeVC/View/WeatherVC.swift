//
//  ViewController.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import UIKit
import NVActivityIndicatorView
import CoreLocation
import RxSwift
class WeatherVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var searchTF: PaddedTextField!
    @IBOutlet weak var weathTB: UITableView!{
        didSet{
            weathTB.register(UINib(nibName: "WeatherTVCell", bundle: nil), forCellReuseIdentifier: "WeatherTVCell")
            weathTB.dataSource = self
            weathTB.delegate = self
            weathTB.rowHeight = 80
        }
    }
    @IBOutlet weak var indicator: NVActivityIndicatorView!
    @IBOutlet weak var weatherCard: UIView!{
        didSet{
            weatherCard.dropShadow()
        }
    }
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var day: UILabel!
    
    //MARK: Vars
    let viewModel = WeatherViewModel()
    var weatherData:WeatherResponse?
    var weatherForecastData:[WeatherList]?
    let locationManager = CLLocationManager()
    let bag = DisposeBag()
    var Latitude:Double?
    var Longutide:Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        weatherCard.alpha = 0
        weatherCard.isHidden = true
        handleResponse()
        requestLocationAccess()
        getDataLocally()
    
    }
    //MARK: fetch from user defauls
    func getDataLocally(){
      //  indicator.showIndicator(start: false)
        let list = UserDefaults.standard.loadForecastsFromUserDefaults()
        if list.count > 0 {
            weatherForecastData = list
            weathTB.reloadData()
        }
    }
    //MARK: gte forcast weather
    func getForcast(){
        var par:[String:Any] = [  "cnt":5,
                                  "appid":Constants.apiKeyValue,
                                  "units":"metric"
        ]
        if  let lat = Latitude {
           par["lat"] = lat
        }
        if  let lon = Longutide {
           par["lon"] = lon
        }
       // indicator.showIndicator(start: true)
        viewModel.getForcast(url: Networking.forecast.fullPath, params: par)
    }
    
    //MARK: handle response
    func handleResponse(){
        viewModel.bindWeather = {[weak self] () in
            self?.indicator.showIndicator(start: false)
            if let weatherData = self?.viewModel.weather {
                self?.weatherCard.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self?.weatherCard.alpha = 1
                    }
                if let icon = weatherData.weather?.first?.icon{
                    self?.icon.setImage(img: Networking.image(iconName: icon).fullPath)
                }
                self?.tempLbl.text = (weatherData.main?.temp_min?.description ?? "") + "°C" + " - " + (weatherData.main?.temp_max?.description ?? "") + "°C"
                self?.day.text = "Today"
            }
        }
        
        viewModel.bindWeatherForcast = {[weak self] () in
            self?.indicator.showIndicator(start: false)
            if let data = self?.viewModel.weatherForcast , data.list.count > 0 {
                self?.indicator.showIndicator(start: false)
                self?.weatherForecastData = data.list
                self?.weathTB.reloadData()
                UserDefaults.standard.saveForecastsToUserDefaults(data.list)
            }
        }
        viewModel.error.observe(on: MainScheduler.instance).subscribe{[weak self] error in
            guard let mes = error.element else {return}
            self?.indicator.showIndicator(start: false)
            self?.weatherCard.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self?.weatherCard.alpha = 0
                }
            self?.createAlert(title: "Attention", message: mes)
        }.disposed(by: bag)
    }
    
 
    
    //MARK: handle taps
    @IBAction func searchTapped(_ sender: Any) {
        if let txt = searchTF.text , !txt.isEmpty{
            var para:[String:Any] = [ "q":txt,
                                      "APPID":Constants.apiKeyValue,
                                      "units":"metric"
            ]
            
            if  let lat = Latitude {
               para["lat"] = lat
            }
            if  let lon = Longutide {
               para["lon"] = lon
            }
            
            indicator.showIndicator(start: true)
            viewModel.getCurrentWeather(url: Networking.weather.fullPath, params: para)
        }else{
            createAlert(title: "Attention", message: "Please enter City name first")
        }
    }
    
}

extension WeatherVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecastData?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTVCell") as? WeatherTVCell else {  return UITableViewCell()}
        if let item = weatherForecastData?[indexPath.row] , let icon = item.weather.first?.icon {
            let temp = item.main.tempMin.description + "°C" + " - " + item.main.tempMax.description + "°C"
            cell.injectCell(iconName: icon, temp: temp , date: item.dtTxt)
        }
        return cell
    }
}
extension WeatherVC: CLLocationManagerDelegate{
    func requestLocationAccess() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            let status = CLLocationManager.authorizationStatus()

             switch status {
             case .notDetermined, .denied, .restricted:
                 locationManager.requestWhenInUseAuthorization()
                 showLocationAccessAlert()
             case .authorizedWhenInUse, .authorizedAlways:
                 locationManager.startUpdatingLocation()
             default:
                 locationManager.requestWhenInUseAuthorization()
                 showLocationAccessAlert()
             }
        }

        // MARK: - CLLocationManagerDelegate

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                locationManager.requestWhenInUseAuthorization()
                showLocationAccessAlert()
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                showLocationAccessAlert()
            @unknown default:
                break
            }
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                print("User location: \(latitude), \(longitude)")
                Latitude = latitude
                Longutide = longitude
                getForcast()
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to get location: \(error.localizedDescription)")
        }
    func showLocationAccessAlert() {
        let alert = UIAlertController(
            title: "Location Access Needed",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }))

        // Present this alert from your view controller:
        self.present(alert, animated: true)
    }
}
