//
//  CitySpec.swift
//  WeatherAppTaskTests
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Quick
import Nimble
@testable import WeatherAppTask

class CitySpec: QuickSpec {
    
    override func spec() {
        
        describe("City Model") {
            
            let name = "TestName"
            let country = "TestCountry"
            
            var city: City!
            var data: Data!
            
            context("After being intialized") {
                
                city = City(id: 0, name: name, country: country)
                
                it("Should return correct id, name, country") {
                    expect(city.id).to(equal(0))
                    expect(city.name).to(equal(name))
                    expect(city.country).to(equal(country))
                }
                
                it("Should keep isMain equal to false") {
                    expect(city.isMain).to(equal(false))
                }
                
                it("Should equal another city if having same id") {
                    let cityB = City(id: 0, name: "232", country: "country")
                    
                    expect(city == cityB).to(equal(true))
                }
                
                it("Should encode successfuly") {
                   let encoder = JSONEncoder()
                    expect { data = try encoder.encode(city) }.toNot(throwAssertion())
                }
                
                it("Should decode successfuly from encoding") {
                    let data =  try! JSONEncoder().encode(city)
                    expect { city = try JSONDecoder().decode(type(of: city), from: data) }.toNot(throwAssertion())
                }
                
            }
        }
    }
}
