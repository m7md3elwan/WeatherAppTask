//
//  WeatherResponse.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

public struct WeatherResponse<T: Codable>: Codable {
    public let code: String
    public let list: T?
    
    enum CodingKeys: String, CodingKey {
        case code = "cod"
        case list
    }
}

