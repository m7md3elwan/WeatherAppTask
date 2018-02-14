//
//  WeatherAPIClient.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa Elwan on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation
import Alamofire

class WeatherAPIClient: APIClient {
    
    internal(set) var apiKey: String
    
    struct constants {
        static var returnDataTypeKey = "mode"
        static var returnDataType = "json"
        static var apiKey = "appid"
        static var successCode = "200"
        static var units = "units"
        static var metric = "metric"
    }
    
    public enum Endpoints: String {
        case searchCity = "find"
        case forecast = "forecast"
    }
    
    public enum HTTPMethod: String {
        case get = "GET" // Currently Api have only get requests
    }
    
    init(baseUrl: String, apiKey: String) {
        self.apiKey = apiKey
        super.init(baseUrl: baseUrl)
    }
    
    fileprivate func url(for endPoint: Endpoints) -> String {
        return "\(baseUrl)\(endPoint.rawValue)"
    }
    
    public  func execute<parseClass:Codable>(endPoint:Endpoints, method:WeatherAPIClient.HTTPMethod , parameters:[String:Any] = [:], completionHandler: @escaping (parseClass?, WeatherAPIClientError?) -> Void ) {
        
        var generalParameters = [String:Any]()
        generalParameters[constants.returnDataTypeKey] = constants.returnDataType
        generalParameters[constants.apiKey] = apiKey
        generalParameters[constants.units] = constants.metric
        
        generalParameters.merge(with: parameters)
        
        super.execute(url: url(for: endPoint), method: Alamofire.HTTPMethod.init(rawValue: method.rawValue)!, parameters: generalParameters) { (response: WeatherResponse<parseClass>?, error) in
            
            guard error == nil else {
                
                if error! is APIClientError {
                    completionHandler(nil, WeatherAPIClientError.technicalDifficulties)
                } else {
                    completionHandler(nil, WeatherAPIClientError.genericError(code: error!.code))
                }
                
                return
            }
            
            guard response!.code == constants.successCode, response!.list != nil else {
                completionHandler(nil, WeatherAPIClientError.weatherApiServerError(code: response!.code));
                return
            }
            
            completionHandler(response!.list!, nil)
        }
    }
}

// Addding a singleton
extension WeatherAPIClient {
    static var shared = WeatherAPIClient(baseUrl: BuildSettings.shared.settings.openWeatherMapBaseUrl,
                                         apiKey: BuildSettings.shared.settings.openWeatherMapApiKey)
}

