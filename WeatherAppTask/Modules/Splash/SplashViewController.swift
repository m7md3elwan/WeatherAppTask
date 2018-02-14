//
//  SplashViewController.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/10/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit
import CoreLocation

class SplashViewController: BaseViewController {
    
    // MARK: Properties
    // MARK: Outlets
    @IBOutlet var logoView: ParentLogoView!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        logoView.show(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard CitiesStore.shared.mainCities.isEmpty else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: { [weak self] in
                self?.showWeatherMainActivityViewController()
            })
            return
        }
        
        actionForLocationStatus()
    }
    
    // MARK: Private Methods
    fileprivate func actionForLocationStatus() {
        switch LocationManager.shared.getLocationServiceState() {
        case .notDetermined:
            LocationManager.shared.delegate = self
        case .allowed:
            LocationManager.shared.startUpdatingLocation()
            LocationManager.shared.delegate = self
        case .denied, .notEnabled:
            CitiesStore.shared.loadDefaultCity()
            self.showWeatherMainActivityViewController()
        }
    }
    
    fileprivate func showWeatherMainActivityViewController() {
        let weatherMainActivityViewController = WeatherMainActivityViewController.instantiateFromStoryboard()
        let weatherNavigationController = UINavigationController(rootViewController: weatherMainActivityViewController)
        present(weatherNavigationController, animated: false, completion: nil)
    }
}

extension SplashViewController: LocationManagerDelegate {
    
    func locationManager(didChangeAuthorization status: LocationServiceState) {
        self.actionForLocationStatus()
    }
    
    func locationManager(didUpdateLocation location:CLLocation) {
        
        if let currentLocation = LocationManager.shared.currentLocation {
            
            LocationManager.shared.stopUpdatingLocation()
            LocationManager.shared.delegate = nil
            
            CitiesStore.shared.searchCity(location: currentLocation, completion: { [weak self] (city, error) in
                
                guard error == nil else {
                    CitiesStore.shared.loadDefaultCity()
                    self?.showWeatherMainActivityViewController()
                    return
                }
                
                city!.isMain = true
                self?.showWeatherMainActivityViewController()
                
            })
            
        }
        
    }
}
