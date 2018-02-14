//
//  WeatherEmptyView.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/10/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

enum WeatherEmptyViewType {
    case loading(title:String, text:String, cta:(()->Void)?)
    case error(title:String, text:String, image:UIImage, cta:(()->Void)?)
}

class WeatherEmptyView: UIView {
    
    var viewType: WeatherEmptyViewType! {
        didSet {
            populateView()
        }
    }
    
    var buttonCTA: (() -> Void)? {
        didSet {
            self.button.isHidden = self.buttonCTA == nil
        }
    }
    
    // MARK: Outlets
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate var imageView: UIImageView!
    @IBOutlet fileprivate var titleLabel: UILabel!
    @IBOutlet fileprivate var textLabel: UILabel!
    @IBOutlet fileprivate var button: UIButton!
    
    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    @IBAction func ctaButtonClicked(_ sender: UIButton) {
        buttonCTA?()
    }
    
    // MARK: Private Methods
    fileprivate func populateView() {
        guard viewType != nil else { return }
    
        switch viewType! {
        case .loading(let title, let text, let cta):
            titleLabel.text = title
            textLabel.text = text
            buttonCTA = cta
            imageView.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        case .error(let title, let text, let image, let cta):
            titleLabel.text = title
            textLabel.text = text
            buttonCTA = cta
            imageView.image = image
            imageView.isHidden = false
            activityIndicator.isHidden = true
        }
    }
}
