//Created by Maxime Wacker on 05/12/2019.
//Copyright © 2019 Max. All rights reserved.

import UIKit
import os

struct  CityDayCellViewModel {
    let date: String
    let weatherImageName: String
}


// The viewModel for CityNextDaysViewController comes from idea
// of grouping item having same day date in same section
// key: day (as isoString) -> value: Cells ViewModel for this day
typealias CityDayViewModel = [String: [CityDayCellViewModel]]

protocol CityNextDaysInteractoring {
    init(for cityID: CityID, netService: CityNextDaysNetServing, router: CityNextDaysRouting)
    func loadCityDays(handler: @escaping (Result<CityDayViewModel, Error>) -> Void)
    
}

class CityNextDaysViewController: UITableViewController {
    private var viewModel = CityDayViewModel()
    private let interactor: CityNextDaysInteractoring
    
    init(interactor: CityNextDaysInteractoring) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reload()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func reload() {
        interactor.loadCityDays() { [weak self] (result: Result<CityDayViewModel, Error>) in
            switch result {
            case .success(let cityDayCellViewModels):
                self?.viewModel = cityDayCellViewModels
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                os_log("Unable to get ViewModel for CityDay Use Case ",
                log: OSLog.webServiceCycle,
                type: .error)
                // Since we now know the type of 'error', we can easily
                // switch on it to perform much better error handling
                // for each possible type of error.
                
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sortedKeys = Array(viewModel.keys).sorted(by: <)
        let sectionValues = viewModel[sortedKeys[section]]
        return sectionValues?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedKeys = Array(viewModel.keys).sorted(by: <)
        let sectionValues = viewModel[sortedKeys[section]]
//        let date = sectionValues
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM yyyy"
//        return dateFormatter.string(from: date)
        return sortedKeys[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let section = indexPath.section
        let row = indexPath.row
        let sortedKeys = Array(viewModel.keys).sorted(by: <)
        let keyForSection = sortedKeys[section]
        let cellViewModel = viewModel[keyForSection]?[row]
        cell.textLabel?.text = cellViewModel?.date
        cell.imageView?.image = UIImage(named: cellViewModel?.weatherImageName ?? "_unknown_")

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
