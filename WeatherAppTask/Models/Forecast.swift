//
//  Forecast.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/14/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

class Forecast: Codable {
    
    var date: Date?
    var mainWeather: MainWeather?
    var weather: [Weather]?
    var wind: Wind?
    
    init() {
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case weather = "weather"
        case mainWeather = "main"
        case wind = "wind"
    }
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        mainWeather = try values.decodeIfPresent(MainWeather.self, forKey: .mainWeather)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        
        if let dateString = try values.decodeIfPresent(String.self, forKey: .date) {
            date = City.formatter.date(from: dateString)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(mainWeather, forKey: .mainWeather)
        try container.encode(weather, forKey: .weather)
        try container.encode(wind, forKey: .wind)
        
        if let date = date {
            try container.encode(City.formatter.string(from: date), forKey: .date)
        }
    }
}

extension Forecast {
    var temperatureText: String {
        if let temperature = mainWeather?.temp {
           return "\(Int(temperature))º"
        } else {
            return "NA".localized
        }
    }
    
    var windSpeedText: String {
        if let windSpeed = wind?.speed {
            return "\(windSpeed) m/s"
        } else {
            return "NA".localized
        }
    }
    
    var iconUrl: String? {
        if let icon = weather?.first?.icon {
            return "\(BuildSettings.shared.settings.openWeatherMapImagesUrl)\(icon).png"
        } else {
            return nil
        }
    }
}
