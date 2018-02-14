//
//  CitiesStore.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation
import CoreLocation

class CitiesStore: Cachable {
    
    // MARK: Properties
    private var defaultCity: City {
        let defaultCity = City(id: 2643743, name: "London", country: "GB")
        defaultCity.isMain = true
        return defaultCity
    }
    
    // MARK: DataSources
    var cities = [City]()
    var mainCities: [City] {
        return cities.filter{ $0.isMain == true }
    }
    
    // MARK:- Methods
    // MARK: Public methods
    func loadDefaultCity (){
        cities.removeAll()
        cities.append(defaultCity)
    }
    
    func add(city: City) {
        guard !cities.contains(city) else { return }
        cities.append(city)
    }
    
    func add(cities:[City]) {
        for city in cities {
            add(city: city)
        }
    }
    
    func searchCity(name:String, completion:@escaping(_ cities:[City]?,_ error: WeatherAPIClientError?)-> Void){
        
        let parameters = ["q":name,
                          "type":"like",
                          "units":"metric"]
        
        WeatherAPIClient.shared.execute(endPoint: WeatherAPIClient.Endpoints.searchCity, method: WeatherAPIClient.HTTPMethod.get, parameters: parameters) { [weak self] (cities:[City]?, error) in
            
            // cache cities
            if let cities = cities {
                self?.add(cities: cities)
            }
            
            completion(cities,error)
        }
    }
    
    func searchCity(location:CLLocation, completion:@escaping(_ city:City?,_ error: WeatherAPIClientError?)-> Void){
        
        let parameters = ["lat":location.coordinate.latitude,
                          "lon":location.coordinate.longitude]
        
        WeatherAPIClient.shared.execute(endPoint: WeatherAPIClient.Endpoints.searchCity, method: WeatherAPIClient.HTTPMethod.get, parameters: parameters) { [weak self] (cities:[City]?, error) in
            
            // cache cities
            if let cities = cities {
                self?.add(cities: cities)
            }
            
            completion(cities?.first, error)
        }
    }
    
    func getForecast(city: City,completion:@escaping(_ cities:[Forecast]?,_ error: WeatherAPIClientError?)-> Void){
        
        let parameters = ["id":city.id]
        
        WeatherAPIClient.shared.execute(endPoint: WeatherAPIClient.Endpoints.forecast, method: WeatherAPIClient.HTTPMethod.get, parameters: parameters) {(forecasts:[Forecast]?, error) in
            completion(forecasts,error)
        }
    }
    
}

// MARK:- Singleton
extension CitiesStore {
    static var shared = CitiesStore()
}


