//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation


// MARK: Dependencies Abractration

protocol CityNextDaysRouting {
    
}

protocol CityNextDaysNetServing {
    func load(for cityID: CityID, handler: @escaping (Result<[CityDaysModel], Error>) -> Void)
}


// MARK: Interactor Implementation
class CityNextDaysInteractor: CityNextDaysInteractoring {
    var cityNextDaysService: CityNextDaysNetServing
    var cityNextDaysRouter: CityNextDaysRouting
    
    required init(netService: CityNextDaysNetServing, router: CityNextDaysRouting){
        self.cityNextDaysService = netService
        self.cityNextDaysRouter = router
    }

}
