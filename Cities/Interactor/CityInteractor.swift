//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation

protocol CityRouting {
    func requestCityNextdaysScreen(for cityName: String)
}

protocol CityNetServing {
    func load(for citiesIDs: [Int], handler: @escaping (Result<[CityModel], Error>) -> Void)
}

class CityInteractor: CityInteractoring {
    var cityNetService: CityNetServing
    required init(cityNetService: CityNetServing){
        self.cityNetService = cityNetService
    }

    func loadCities(cityIDs: [Int], handler: @escaping (Result<[CityCellViewModel], Error>) -> Void) {
        cityNetService.load(for: cityIDs) {
            (result: Result<[CityModel], Error>) in
            switch result {
            case .success( let cityModels):
                let cityCellViewModels: [CityCellViewModel] = cityModels.map { (cityModel: CityModel) -> CityCellViewModel in
                    let iconID = (cityModel.weatherItems.first?.icon ?? ._unknown_ ).rawValue
                    return CityCellViewModel(weatherImageName: iconID, cityName: cityModel.name)
                }
                handler(.success(cityCellViewModels))
                break
            case .failure(let error):
                handler(.failure(error))
                break
            }
        }
    }
}
