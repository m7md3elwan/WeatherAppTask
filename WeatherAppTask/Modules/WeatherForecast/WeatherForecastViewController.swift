//
//  WeatherForecastViewController.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/13/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit
import DateToolsSwift

struct DayForeCast {
    var date: Date
    var foreCasts: [Forecast]
}

class WeatherForecastViewController: BaseViewController {
    
    struct constants {
        static var cellReuseIdentifier = "ForecastCollectionViewCell"
        static var headerReuseIdentifier = "ForecastHeaderCollectionViewCell"
    }
    
    // MARK:- Properties
    var viewState = ViewState.default {
        didSet {
            setCollectionViewBackgroundView(for: viewState)
        }
    }
    
    // MARK: Outlets
    @IBOutlet var weatherWidget: CityWeatherWidget!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var addToMainBarItem: UIBarButtonItem!
    
    // MARK:- DataSources
    var city:City!
    
    fileprivate var foreCastForDay = [Date: [Forecast]]() {
        didSet {
            foreCasts.removeAll()
            var unSortedForeCasts = [DayForeCast] ()
            for (key, value) in foreCastForDay {
                unSortedForeCasts.append(DayForeCast(date: key, foreCasts: value))
            }
            foreCasts = unSortedForeCasts.sorted{ $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 }
        }
    }
    
    fileprivate var foreCasts = [DayForeCast]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        configureAddToMainActivityActionBarItem()
        
        weatherWidget.configure(city: city)
        
        // fetch forecast
        fetchForeCast()
        
        if city.foreCast.isEmpty {
            self.viewState = .loading
        } else {
            self.viewState = .default
            foreCastForDay = (city.foreCast.categorise{ $0.date!.start(of: .day) })
        }
        
    }
    
    // MARK:- Methods
    // MARK: Actions
    @IBAction func addToMainBarItemTapped(_ sender: UIBarButtonItem) {
        if !city.isMain {
            if !CitiesStore.shared.addToMainActivities(city: city) {
                showAlert(viewController: self.topNonPresentingViewController(), title: "Error".localized, message: "ReachedMaximumCities".localized, actionTitle: "OK".localized)
            }
        } else {
            CitiesStore.shared.removeFromMainActivities(city: city)
        }
        configureAddToMainActivityActionBarItem()
    }
    // MARK: Public methods
    
    // MARK: Private methods
    fileprivate func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func fetchForeCast() {
        CitiesStore.shared.getForecast(city: city) { [weak self] (cities, error) in
            guard error == nil else {
                switch error! {
                case .genericError(let code) where code == KErrorInternetConnection :
                    if self?.city.foreCast.count == 0 {
                        self?.viewState = .noConnection
                    }
                case .technicalDifficulties, .weatherApiServerError(_), .genericError(_) :
                    if self?.city.foreCast.count == 0 {
                        self?.viewState = .error
                    }
                }
                return
            }
            
            self?.city.foreCast = cities!
            self?.viewState = .default
            self?.foreCastForDay = (self?.city.foreCast.categorise{ $0.date!.start(of: .day) })!
        }
    }
    
    fileprivate func configureAddToMainActivityActionBarItem() {
        if city.isMain {
            addToMainBarItem.image = #imageLiteral(resourceName: "remove")
        } else {
            addToMainBarItem.image = #imageLiteral(resourceName: "add")
        }
    }
    
    fileprivate func setCollectionViewBackgroundView(for state: ViewState) {
        let emptyView = WeatherEmptyView(frame: collectionView.bounds)
        switch state {
        case .default:
            collectionView.backgroundView = nil
        case .loading:
            emptyView.viewType = WeatherEmptyViewType.loading(title: "Loading".localized, text: "PleaseWait".localized, cta: nil)
            collectionView.backgroundView = emptyView
        case .noResults:
            emptyView.viewType = WeatherEmptyViewType.error(title: "NoResults".localized, text: "NoResultsDescription".localized, image: #imageLiteral(resourceName: "Empty"), cta: {
                self.viewState = .loading
                self.fetchForeCast()
            })
            collectionView.backgroundView = emptyView
        case .error:
            emptyView.viewType = WeatherEmptyViewType.error(title: "Error".localized, text: "ServerError".localized, image: #imageLiteral(resourceName: "Error"), cta: {
                self.viewState = .loading
                self.fetchForeCast()
            })
            collectionView.backgroundView = emptyView
        case .noConnection:
            emptyView.viewType = WeatherEmptyViewType.error(title: "Error".localized, text: "NoInternet".localized, image: #imageLiteral(resourceName: "Error"), cta: {
                self.viewState = .loading
                self.fetchForeCast()
            })
            collectionView.backgroundView = emptyView
        }
    }
}

//MARK:- UICollectionViewDataSource
extension WeatherForecastViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return foreCasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: constants.headerReuseIdentifier, for: indexPath) as! ForecastDayCollectionReusableView
        view.configure(date: foreCasts[indexPath.section].date)
        return view
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foreCasts[section].foreCasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: constants.cellReuseIdentifier, for: indexPath) as! ForecastCollectionViewCell
        cell.configure(forecast: foreCasts[indexPath.section].foreCasts[indexPath.row])
        return cell
    }
}

extension WeatherForecastViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.frame.width/2) - 12
        
        return CGSize(width: cellWidth , height: cellWidth )
    }
}

