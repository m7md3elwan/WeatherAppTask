//
//  WeatherAPIClientErrors.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/10/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

enum WeatherAPIClientError: LocalizedError {
    case technicalDifficulties
    case weatherApiServerError(code:String)
    case genericError(code:Int) // Generic HTTP Error Response Codes

    public var errorDescription: String? {
        switch self {
        case .technicalDifficulties:
            return "technicalDifficultiesError".localized
        case .weatherApiServerError(_):
            return "weatherApiServerError".localized
        case .genericError(_):
            return "genericError".localized
        }
    }
}
