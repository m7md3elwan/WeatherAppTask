//
//  Error+Code.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

let KErrorInternetConnection = -1009

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
    
    func isNoInternet() -> Bool {
        return self.code == KErrorInternetConnection
    }
}
