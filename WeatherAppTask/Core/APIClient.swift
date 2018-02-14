//
//  APIClient.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation
import Alamofire

enum APIClientError: Int, LocalizedError {
    case parsingError
    
    public var errorDescription: String? {
        switch self {
        case .parsingError:
            return "technicalDifficulties".localized
        }
    }
}

class APIClient {
    
    internal(set) var baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    public func execute<parseClass:Codable>(url:String, method:HTTPMethod , parameters:[String:Any] = [:], completionHandler: @escaping (parseClass?, Error?) -> Void ) {
        
        Alamofire.request(url, method: method, parameters: parameters, headers: nil).responseData { (response) in
            
            switch response.result {
            case .success(let data):
                do {
                    let object = try JSONDecoder().decode(parseClass.self, from: data)
                    completionHandler(object, nil)
                }
                catch {
                    completionHandler(nil, APIClientError.parsingError)
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
            
        }
    }
}
