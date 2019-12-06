//Created by Maxime Wacker on 05/12/2019.
//Copyright © 2019 Max. All rights reserved.

import UIKit

struct CityCellViewModel {
    let weatherImageName: String // Images to be taken from https://openweathermap.org/weather-conditions
    let cityName : String
}

protocol CityRouting {
    func requestCityNextdaysScreen(for cityName: String)
}

protocol CityInteractoring {
    func loadCities(cityIDs:[Int], handler: @escaping (Result<[CityCellViewModel], Error>) -> Void)
    //func requestDetails(for city: CityModel) // Maybe just cityID
}

class CitiesTableViewController: UITableViewController {
//    let router: CityRouting
    private var viewModel = [CityCellViewModel]()
    
    let interactor: CityInteractoring
    
    init(interactor: CityInteractoring) {
        //self.router = router
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
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // FIXME: Load This from UserDefaults
        let londonID = 2643743
        let moscowID = 524901
        let kievID = 703448
        interactor.loadCities(cityIDs: [londonID, moscowID, kievID]) { [weak self] (result: Result<[CityCellViewModel], Error>) in
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        //let row = indexPath.row
        //let selectedCityName = viewModel[row].cityName
        //interactor.requestCityNextdaysScreen(for: selectedCityName)
    }
     
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
}
