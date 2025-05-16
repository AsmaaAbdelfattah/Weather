//
//  NetworkService.swift
//  Weather
//
//  Created by asma abdelfattah on 15/05/2025.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func getData<T: Decodable>(url: String, parms: [String: Any], compilationHandler: @escaping (Result<T, Error>) -> Void)
}

class NetworkService:NetworkServiceProtocol{
    private static var networkService : NetworkService?
    public static func getInstance()->NetworkService{
        if networkService == nil {
            networkService = NetworkService()
        }
        return networkService!
    }
    //MARK: fetch weather data with parameters
    func getData<T: Decodable> (url: String,parms:[String:Any],compilationHandler: @escaping (Result<T , Error>) -> Void){
        print(parms)
//        AF.request(url, method: .get , parameters: parms, encoding: URLEncoding.default).responseJSON(completionHandler: { rawResponse in
//                debugPrint(rawResponse) // 🔍 Print full raw JSON
//            })

        AF.request(url, method: .get , parameters: parms,encoding: URLEncoding.default).responseDecodable(of: T.self, completionHandler: { response in
            print(url)
            switch response.result {
            case .success(let val):
                compilationHandler(.success(val))
            case .failure(let error):
                compilationHandler(.failure(error))
            }
        })
    }
}
