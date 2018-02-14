//
//  UIViewController+topNonPresentingViewController.swift.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/14/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func topNonPresentingViewController() -> UIViewController
    {
        if self.presentedViewController == nil {
            return self
        } else {
            return self.presentedViewController!.topNonPresentingViewController()
        }
    }

}
