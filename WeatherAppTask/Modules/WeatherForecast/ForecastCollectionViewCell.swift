//
//  ForecastCollectionViewCell.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/14/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet var forecastWidget: ForecastWidget!
    
    func configure(forecast: Forecast) {
        forecastWidget.configure(forecast: forecast)
    }

    
}
