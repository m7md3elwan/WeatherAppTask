//
//  DayWidget.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/10/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit
import DateToolsSwift

class DayWidget: UIView {

    @IBOutlet var dateLabel: UILabel!
    
    func configure(date: Date) {
        dateLabel.text = date.format(with: "EEEE, MMM d, yyyy")
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
