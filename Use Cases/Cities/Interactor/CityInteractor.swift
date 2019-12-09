//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation

protocol CityRouting {
    func requestCityNextdaysScreen(for cityID: Int)
    func requestCityAdd(handler: @escaping (String) -> Void)
}

protocol CityNetServing {
    func load(for citiesIDs: [CityID], handler: @escaping (Result<[CityModel], Error>) -> Void)
    func loadCity(named name: String, handler: @escaping (Result<CityModel, Error>) -> Void)
}

protocol CityStoring {
    func retrieveStoredCityIDs() -> [CityID]
    func store( _ cityID: CityID)
    func remove( _ cityID: CityID)
}

class CityInteractor: CityInteractoring {

    let cityNetService: CityNetServing
    let cityRouter: CityRouting
    let cityStorage: CityStoring
    
    required init(netService: CityNetServing, storage: CityStoring, router: CityRouting){
        self.cityStorage = storage
        self.cityNetService = netService
        self.cityRouter = router
    }

    func loadCities(handler: @escaping (Result<[CityCellViewModel], Error>) -> Void) {
        cityNetService.load(for: self.cityStorage.retrieveStoredCityIDs()) {
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
    
    func requestCityNextdaysScreen(for id: CityID) {
        cityRouter.requestCityNextdaysScreen(for: id)
    }
    
    func requestCityAdd(handler: @escaping (Result<Void, Error>) -> Void) {
        cityRouter.requestCityAdd(){ [weak self] cityName in
            self?.cityNetService.loadCity(named: cityName) { cityResult in
                switch cityResult {
                case .success(let cityModel):
                    self?.cityStorage.store(cityModel.id)
                    handler(.success(()))
                case .failure(let error):
                    print(error)
                    // Since we now know the type of 'error', we can easily
                    // switch on it to perform much better error handling
                    // for each possible type of error.
                }
            }
        }
    }
    
    
    func requestCityRemove(cityID: CityID, handler: @escaping ([CityCellViewModel]) -> Void) {
        self.cityStorage.remove(cityID)
        cityNetService.load(for: self.cityStorage.retrieveStoredCityIDs()) {
            (result: Result<[CityModel], Error>) in
            switch result {
            case .success( let cityModels):
                let cityCellViewModels: [CityCellViewModel] = cityModels.map { (cityModel: CityModel) -> CityCellViewModel in
                    let iconID = (cityModel.weatherItems.first?.icon ?? ._unknown_ ).rawValue
                    return CityCellViewModel(id: cityModel.id, cityName: cityModel.name, weatherImageName: iconID)
                }
                handler(cityCellViewModels)
                break
            case .failure(_):
                break
            }
        }
        
    }
}
