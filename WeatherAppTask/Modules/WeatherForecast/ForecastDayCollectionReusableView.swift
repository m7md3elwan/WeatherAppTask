//
//  ForecastDayCollectionReusableView.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/14/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class ForecastDayCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet var dayWidget: DayWidget!
    
    func configure(date: Date) {
        dayWidget.configure(date: date)
    }
    
}
