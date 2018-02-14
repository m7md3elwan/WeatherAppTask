//
//  CityWeatherWidget.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/10/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class CityWeatherWidget: UIView {

    @IBOutlet var cityTitleLabel: UILabel!
    
    func configure(city: City) {
        var cityName = city.name
        
        if !city.country.isEmpty {
            cityName = "\(city.name), \(city.country)"
        }
        
        cityTitleLabel.text = cityName
    }
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
}
