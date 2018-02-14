//
//  Weather.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/13/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

class Weather: Codable {
    var id: Int?
    var main: String?
    var text: String?
    var icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case text = "description"
        case icon = "icon"
    }
    
}
