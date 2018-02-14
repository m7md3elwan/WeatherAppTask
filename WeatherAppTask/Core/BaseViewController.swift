//
//  BaseViewController.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/13/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    func showAlert(title: String,
                   message: String,
                   actionTitle: String,
                   cancelTitle: String,
                   actionHandler:(()->Void)?,
                   cancelHandler:(()->Void)? ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
