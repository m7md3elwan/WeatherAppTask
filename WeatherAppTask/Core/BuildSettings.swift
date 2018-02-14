//
//  BuildSettings.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

enum BuildSettings {
    
    #if DEBUG
        static let shared = BuildSettings.development
    #else
        static let shared = BuildSettings.production
    #endif
    
    case production
    case development
    
    var settings: BuildSetting {
        get {
            switch self {
            case .production:
                return BuildSetting(openWeatherMapBaseUrl: "https://api.openweathermap.org/data/2.5/",
                                    openWeatherMapImagesUrl: "https://openweathermap.org/img/w/",
                                    openWeatherMapApiKey: "b920a829a2efc7436a66d6a248b09e27",
                                    showContentStringKeys: false)
            case .development:
                return BuildSetting(openWeatherMapBaseUrl: "https://api.openweathermap.org/data/2.5/",
                                    openWeatherMapImagesUrl: "https://openweathermap.org/img/w/",
                                    openWeatherMapApiKey: "b920a829a2efc7436a66d6a248b09e27",
                                    showContentStringKeys: true)
            }
        }
    }
    
    var localizedDescripton: String {
        get {
            switch self {
            case .production:
                return "Uses production settings"
            case .development:
                return "Uses development settings"
            }
        }
    }
    
    struct BuildSetting: Codable {
        var openWeatherMapBaseUrl: String
        var openWeatherMapImagesUrl: String
        var openWeatherMapApiKey: String
        var showContentStringKeys: Bool
    }
}

