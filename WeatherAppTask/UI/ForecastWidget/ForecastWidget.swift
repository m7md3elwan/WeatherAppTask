//
//  ForecastWidget.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/14/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit
import SDWebImage

class ForecastWidget: UIView {
    
    // MARK: Outlets
    @IBOutlet var weatherLogoImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    // MARK: Public Methods
    func configure(forecast: Forecast) {
        weatherLogoImageView.sd_setImage(with: URL(string: forecast.iconUrl ?? ""))
        
        weatherDescriptionLabel.text = forecast.weather?.first?.main
        
        timeLabel.text = forecast.date!.format(with: "HH:mm")
        temperatureLabel.text = forecast.temperatureText
        windSpeedLabel.attributedText = generateTitleValueString(title: "wind".localized, value: forecast.windSpeedText)
        humidityLabel.attributedText = generateTitleValueString(title: "humidity".localized, value: forecast.mainWeather?.humidity)
    }
}

extension ForecastWidget {
    
    fileprivate func generateTitleValueString<T>(title:String, value:T?) -> NSMutableAttributedString
    {
        guard value != nil else {
            return NSMutableAttributedString(string: "")
        }
        let titleAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13)]
        let timesAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]
        
        let titlePart = NSMutableAttributedString(string: "\(title): ", attributes: titleAttributes)
        let timePart = NSMutableAttributedString(string: "\(value!)", attributes: timesAttributes)
        
        let combination = NSMutableAttributedString()
        combination.append(titlePart)
        combination.append(timePart)
        
        return combination
    }
}
