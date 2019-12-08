//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation


// MARK: Dependencies Abractration

protocol CityNextDaysRouting {
    
}

protocol CityNextDaysNetServing {
    func load(for cityID: CityID, handler: @escaping (Result<[CityDayModel], Error>) -> Void)
}


// MARK: Interactor Implementation
class CityNextDaysInteractor: CityNextDaysInteractoring {
 
    let cityID: CityID
    var cityNextDaysService: CityNextDaysNetServing
    var cityNextDaysRouter: CityNextDaysRouting
    
    required init(for cityID: CityID, netService: CityNextDaysNetServing, router: CityNextDaysRouting){
        self.cityID = cityID
        self.cityNextDaysService = netService
        self.cityNextDaysRouter = router
    }

    func loadCityDays(handler: @escaping (Result<[CityDayCellViewModel], Error>) -> Void) {
        cityNextDaysService.load(for: self.cityID) {
            (result: Result<[CityDayModel], Error>) in
            switch result {
            case .success( let cityDays):
                let cityCellViewModels: [CityDayCellViewModel] = cityDays.map { (cityDay: CityDayModel) -> CityDayCellViewModel in
                    let iconID = (cityDay.weatherItems.first?.icon ?? ._unknown_ ).rawValue
                    let date = "\(cityDay.date)"
                    return CityDayCellViewModel(date: date, weatherImageName: iconID)
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
