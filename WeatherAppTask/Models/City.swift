//
//  City.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

class City: Forecast {
    
    var isMain: Bool = false
    var id: Int
    var name: String
    var country: String
    var foreCast = [Forecast]()
    
    init(id: Int, name: String, country: String) {
        self.id = id
        self.name = name
        self.country = country
        
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case isMain

        case id
        case name
        
        case foreCast
        
        case sys // Container of country
    }
    
    enum SysKeys: String, CodingKey {
        case country
    }
    
    required init(from decoder: Decoder) throws {        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode isMain if exists as it is not returned from Api & can't be nil
        if let isMain = try values.decodeIfPresent(Bool.self, forKey: .isMain) {
            self.isMain = isMain
        }
        
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
        let sys = try values.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        country = try sys.decode(String.self, forKey: .country)
        
        if let foreCast = try values.decodeIfPresent([Forecast].self, forKey: .foreCast) {
            self.foreCast = foreCast
        }
        
        try super.init(from: decoder)
        
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isMain, forKey: .isMain)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        var sys = container.nestedContainer(keyedBy: SysKeys.self, forKey: .sys)
        try sys.encode(country, forKey: .country)
        
        try container.encode(foreCast, forKey: .foreCast)
        
        try super.encode(to: encoder)
    }
}

// MARK:- Equatable
extension City: Equatable {
    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}
