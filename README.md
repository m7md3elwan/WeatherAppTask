# WeatherAppTask
App that show weather forecast & user can add up to 5 cities to main activity

## Disscussion

The project is build using Swift 4 & Xcode 9.0

### Build settings

Project support 2 running modes according to scheme 
Debug scheme will show showContentStringKeys instead of actual content strings

```
    #if DEBUG
        static let shared = BuildSettings.development
    #else
        static let shared = BuildSettings.production
    #endif
```

## Pods used

* [Alamofire](https://github.com/Alamofire/Alamofire) - HTTP Networking in Swift
* [SDWebImage](https://github.com/rs/SDWebImage) - Asynchronous image downloader with cache support
* [TPKeyboardAvoiding](https://github.com/michaeltyson/TPKeyboardAvoiding) - Moves text fields out of the way of the keyboard in iOS
* [DateToolsSwift](https://github.com/MatthewYork/DateTools) - Dates & time helpers
* [Quick](https://github.com/Quick/Quick) - Testing framework.
* [Nimble](https://github.com/Quick/Nimble) - Matcher Framework for Swift 


## Authors

* **Mohamed Elwan** 
