
//  ContentStringsManager.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation

class ContentStringsManager: Cachable{
    
    // Keys
    struct keys {
        static let resourceName = "Strings"
        static let contentStrings = "contentStrings"
    }
    
    // Singleton
    static var shared = ContentStringsManager()
    
    // DataSource
    var contentStrings:[String: String]!
    
    // Variables
    func string(for key:String, buildSettings: BuildSettings = BuildSettings.shared) -> String {
       
        if buildSettings.settings.showContentStringKeys {
            return key
        }
        
        // Load Content Strings if not loaded
        if contentStrings == nil {
            loadContentStringsFromBundleIfValid()
        }
        
        return contentStrings[key] ?? ""
        
    }
    
    fileprivate func loadContentStringsFromBundleIfValid() {
        if let path = Bundle.main.path(forResource: keys.resourceName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let contentStrings = jsonResult[keys.contentStrings] as? [String:String] {
                    self.contentStrings = contentStrings
                }
            } catch {
                self.contentStrings = [String:String]()
            }
        }
    }
}

extension String {
    var localized: String {
        get{
            return ContentStringsManager.shared.string(for: self)
        }
    }
}

