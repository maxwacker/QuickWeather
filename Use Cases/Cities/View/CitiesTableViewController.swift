//Created by Maxime Wacker on 05/12/2019.
//Copyright © 2019 Max. All rights reserved.

import UIKit

struct CityCellViewModel {
    let id: CityID
    let cityName: String
    let weatherImageName: String // Images to be taken from https://openweathermap.org/weather-conditions
}

protocol CityInteractoring {
    init(initCityIDs: [CityID], netService: CityNetServing, storage: CityStoring, router: CityRouting)
    func loadCities(handler: @escaping (Result<[CityCellViewModel], Error>) -> Void)
    func requestCityNextdaysScreen(for cityID: CityID)
    func requestCityAdd(handler: @escaping (Result<Void, Error>) -> Void)
    func requestCityRemove(cityID: CityID, handler: @escaping ([CityCellViewModel]) -> Void)
}

class CitiesTableViewController: UITableViewController {
    private var viewModel = [CityCellViewModel]()
    private let interactor: CityInteractoring
    
    init(interactor: CityInteractoring) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addTapped))
        
        self.reload()
    }

    private func reload() {
        interactor.loadCities() { [weak self] (result: Result<[CityCellViewModel], Error>) in
            switch result {
            case .success(let cityCellViewModels):
                self?.viewModel = cityCellViewModels
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                // Since we now know the type of 'error', we can easily
                // switch on it to perform much better error handling
                // for each possible type of error.
                
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let row = indexPath.row
        cell.textLabel?.text = viewModel[row].cityName
        cell.imageView?.image = UIImage(named: viewModel[row].weatherImageName)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let selectedCityID = viewModel[row].id
        interactor.requestCityNextdaysScreen(for: selectedCityID)
    }
     
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = indexPath.row
            let cityIDToRemove = viewModel[row].id
            interactor.requestCityRemove(cityID: cityIDToRemove) { [weak self] viewModel in
                self?.viewModel = viewModel
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
        
    @objc func addTapped() {
        interactor.requestCityAdd() { [weak self] voidResult in
            switch voidResult {
             case .success(_):
                self?.reload()
             case .failure(let error):
                 print(error)
                 // Since we now know the type of 'error', we can easily
                 // switch on it to perform much better error handling
                 // for each possible type of error.
             }
            
        }
    }
    
}
