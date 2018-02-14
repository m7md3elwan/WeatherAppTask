//
//  Dictionary+Merge.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/13/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
