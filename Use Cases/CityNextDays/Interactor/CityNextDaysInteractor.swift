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
    let cityNextDaysService: CityNextDaysNetServing
    let cityNextDaysRouter: CityNextDaysRouting
    
    let dateFormatter = DateFormatter()

    
    required init(for cityID: CityID, netService: CityNextDaysNetServing, router: CityNextDaysRouting){
        self.cityID = cityID
        self.cityNextDaysService = netService
        self.cityNextDaysRouter = router
        
        dateFormatter.locale = Locale(identifier: "fr_FR") // FIXME : Take local from User Settings
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }

    private func tranformToCityDayCellVM(from cityDayModel: CityDayModel) -> CityDayCellViewModel {
        let iconID = (cityDayModel.weatherItems.first?.icon ?? ._unknown_ ).rawValue
        let date = self.dateFormatter.string(from: cityDayModel.date)
        return CityDayCellViewModel(date: date, weatherImageName: iconID)
    }
    
    private func transformToCityDayViewModel(from models: [CityDayModel]) -> CityDayViewModel {
        let keyDateformatter = DateFormatter()
        keyDateformatter.dateFormat = "yyyy-MM-dd"
        return models.reduce(CityDayViewModel()) { cityDayViewModel, cityDayModel in
            var updatableCityDayViewModel = cityDayViewModel
            let modelDayKey = keyDateformatter.string(from: cityDayModel.date)
            if updatableCityDayViewModel.keys.contains(modelDayKey) {
                updatableCityDayViewModel[modelDayKey]?.append(tranformToCityDayCellVM(from: cityDayModel))
            } else {
                updatableCityDayViewModel[modelDayKey] = [tranformToCityDayCellVM(from: cityDayModel)]
            }
            return updatableCityDayViewModel
        }
    }
    
    func loadCityDays(handler: @escaping (Result<CityDayViewModel, Error>) -> Void) {
        cityNextDaysService.load(for: self.cityID) { [weak self]
            (result: Result<[CityDayModel], Error>) in
            guard let self = self else { return }
            switch result {
            case .success( let cityDays):
                handler(.success(self.transformToCityDayViewModel(from: cityDays)))
                break
            case .failure(let error):
                handler(.failure(error))
                break
            }
        }
    }
    
}
