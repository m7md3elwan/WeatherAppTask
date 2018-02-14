//
//  WeatherMainActivityViewController.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import UIKit

enum WeatherMainActivityViewControllerViewState {
    case showingMainCities
    case showingSearchResults(viewState:ViewState)
}

class WeatherMainActivityViewController: BaseViewController {
    
    // MARK:- Properties
    var searchController: UISearchController!
    var viewState = WeatherMainActivityViewControllerViewState.showingMainCities {
        didSet {
            tableView.reloadData()
            setTableBackgroundView(for: viewState)
        }
    }
    
    // MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    // MARK:- DataSources
    var mainActiviyCities = [City]() {
        didSet {
            tableView?.reloadData()
        }
    }
    var searchResults = [City]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WeatherMainActivity_Title".localized
        setUpTableView()
        setUpSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadMainCities()
    }
    
    // MARK:- Methods
    // MARK: Actions
    
    // MARK: Public methods
    
    // MARK: Private methods
    fileprivate func reloadMainCities() {
        mainActiviyCities = CitiesStore.shared.mainCities
        tableView.reloadData()
        setTableBackgroundView(for: viewState)
    }
    
    fileprivate func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setUpSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }
    
    fileprivate func setTableBackgroundView(for viewState:WeatherMainActivityViewControllerViewState) {
        switch viewState {
        case .showingMainCities:
            if mainActiviyCities.isEmpty {
                let emptyView = WeatherEmptyView(frame: tableView.bounds)
                emptyView.viewType = WeatherEmptyViewType.error(title: "NoResults".localized, text: "NoMainActivityResultsDescription".localized, image: #imageLiteral(resourceName: "Empty"), cta: nil)
                tableView.backgroundView = emptyView
            } else {
                tableView.backgroundView = nil
            }
        case .showingSearchResults(let state):
            let emptyView = WeatherEmptyView(frame: tableView.bounds)
            switch state {
            case .default:
                tableView.backgroundView = nil
            case .loading:
                emptyView.viewType = WeatherEmptyViewType.loading(title: "Loading".localized, text: "PleaseWait".localized, cta: nil)
                tableView.backgroundView = emptyView
            case .noResults:
                tableView.backgroundView = nil
            case .error:
                emptyView.viewType = WeatherEmptyViewType.error(title: "Error".localized, text: "ServerError".localized, image: #imageLiteral(resourceName: "Error"), cta: { [weak self] in
                    if let searchBar = self?.searchController?.searchBar {
                        self?.reload(searchBar)
                    }
                })
                tableView.backgroundView = emptyView
            case .noConnection:
                emptyView.viewType = WeatherEmptyViewType.error(title: "Error".localized, text: "NoInternet".localized, image: #imageLiteral(resourceName: "Error"), cta: { [weak self] in
                    if let searchBar = self?.searchController?.searchBar {
                        self?.reload(searchBar)
                    }
                })
                tableView.backgroundView = emptyView
            }
        }
    }
    
    fileprivate func showWeatherForecastViewController(with city: City) {
        let weatherForecastViewController = WeatherForecastViewController.instantiateFromStoryboard()
        weatherForecastViewController.city = city
        self.navigationController?.pushViewController(weatherForecastViewController, animated: true)
        
    }
}

// MARK:- UITableViewDataSource
extension WeatherMainActivityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewState {
        case .showingMainCities:
            return mainActiviyCities.count
        case .showingSearchResults(_):
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewState {
        case .showingMainCities:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameTableViewCell", for: indexPath) as! CityNameTableViewCell
            cell.configure(city: mainActiviyCities[indexPath.row])
            return cell
        case .showingSearchResults(_):
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameTableViewCell", for: indexPath) as! CityNameTableViewCell
            cell.configure(city: searchResults[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var actionedCity: City!
        
        switch viewState {
        case .showingMainCities:
            actionedCity = mainActiviyCities[indexPath.row]
        case .showingSearchResults(_):
            actionedCity = searchResults[indexPath.row]
            
        }
        
        if actionedCity.isMain == true {
            let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { [weak self] (rowAction, indexPath) in
                CitiesStore.shared.removeFromMainActivities(city: actionedCity)
                self?.reloadMainCities()
            }
            deleteAction.backgroundColor = .red
            return [deleteAction]
        } else {
            let addAction = UITableViewRowAction(style: .normal, title: "Add") {[weak self] (rowAction, indexPath) in
                if !CitiesStore.shared.addToMainActivities(city: actionedCity) {
                    self?.showAlert(viewController: self?.topNonPresentingViewController(),title: "Error".localized, message: "ReachedMaximumCities".localized, actionTitle: "OK".localized)
                }
                self?.reloadMainCities()
            }
            addAction.backgroundColor = .blue
            return [addAction]
        }
    }
}

// MARK:- UITableViewDelegate
extension WeatherMainActivityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewState {
        case .showingMainCities:
            showWeatherForecastViewController(with: mainActiviyCities[indexPath.row])
        case .showingSearchResults(_):
            showWeatherForecastViewController(with: searchResults[indexPath.row])
        }
    }
}

// MARK:- UISearchControllerDelegate
extension WeatherMainActivityViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}


// MARK:- UISearchControllerDelegate
extension WeatherMainActivityViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.viewState = .showingSearchResults(viewState: ViewState.default)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.viewState = .showingMainCities
        searchResults.removeAll()
    }
}

// MARK:- UISearchResultsUpdating
extension WeatherMainActivityViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchController.searchBar)
        perform(#selector(self.reload(_:)), with: searchController.searchBar, afterDelay: 0.75)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespaces), text.count > 2 else { return }
        self.searchResults.removeAll()
        self.viewState = .showingSearchResults(viewState: ViewState.loading)
        
        CitiesStore.shared.searchCity(name: text) { [text, weak self] (cities, error) in
            guard error == nil else {
                switch error! {
                case .genericError(let code) where code == KErrorInternetConnection :
                    self?.viewState = .showingSearchResults(viewState: ViewState.noConnection)
                case .technicalDifficulties, .weatherApiServerError(_), .genericError(_) :
                    self?.viewState = .showingSearchResults(viewState: ViewState.error)
                }
                return
            }
            
            guard searchBar.text == text else {
                self?.viewState = .showingSearchResults(viewState: ViewState.loading)
                return
            }
            
            self?.searchResults = cities!
            self?.viewState = .showingSearchResults(viewState: ViewState.default)
            print(text)
            
        }
    }
}
