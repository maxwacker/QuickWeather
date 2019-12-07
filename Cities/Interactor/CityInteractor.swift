//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation

protocol CityRouting {
    func requestCityNextdaysScreen(for cityID: Int)
}

protocol CityNetServing {
    func load(for citiesIDs: [Int], handler: @escaping (Result<[CityModel], Error>) -> Void)
}

class CityInteractor: CityInteractoring {
    let cityIDs: [CityID]
    var cityNetService: CityNetServing
    var cityRouter: CityRouting
    
    required init(initCityIDs: [CityID], netService: CityNetServing, router: CityRouting){
        self.cityIDs = initCityIDs
        self.cityNetService = netService
        self.cityRouter = router
    }

    func loadCities(handler: @escaping (Result<[CityCellViewModel], Error>) -> Void) {
        cityNetService.load(for: self.cityIDs) {
            (result: Result<[CityModel], Error>) in
            switch result {
            case .success( let cityModels):
                let cityCellViewModels: [CityCellViewModel] = cityModels.map { (cityModel: CityModel) -> CityCellViewModel in
                    let iconID = (cityModel.weatherItems.first?.icon ?? ._unknown_ ).rawValue
                    return CityCellViewModel(id: cityModel.id, cityName: cityModel.name, weatherImageName: iconID)
                }
                handler(.success(cityCellViewModels))
                break
            case .failure(let error):
                handler(.failure(error))
                break
            }
        }
    }
    
    func requestCityNextdaysScreen(for id: Int) {
        cityRouter.requestCityNextdaysScreen(for: id)
    }
    
}
