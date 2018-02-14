//
//  BaseViewController.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/13/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showAlert(viewController: UIViewController?,
                   title: String,
                   message: String,
                   actionTitle: String,
                   cancelTitle: String? = nil,
                   actionHandler:(()->Void)? = nil,
                   cancelHandler:(()->Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
        alert.addAction(okAction)
        
        if cancelTitle != nil {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
                cancelHandler?()
            }
            
            alert.addAction(cancelAction)
        }
        
        viewController?.present(alert, animated: true, completion: nil)
    }
}
