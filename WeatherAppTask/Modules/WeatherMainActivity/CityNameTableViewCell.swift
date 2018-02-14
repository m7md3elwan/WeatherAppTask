//
//  CityNameTableViewCell.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/14/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class CityNameTableViewCell: UITableViewCell {
    
    @IBOutlet var weatherWidget: CityWeatherWidget!
    
    func configure(city: City) {
        weatherWidget.configure(city: city)
    }

}
