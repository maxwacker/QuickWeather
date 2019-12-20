//Created by Maxime Wacker on 09/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation
import os

struct CityStorage : CityStoring {
    let citiesIDStorageKey = "SavedCityIDs"
    let defaults = UserDefaults.standard

    func retrieveStoredCityIDs() -> [CityID] {
        let savedCityIDs = defaults.object(forKey: citiesIDStorageKey) as? [CityID] ?? [CityID]()
        return savedCityIDs
    }
    
    func store(_ cityID: CityID) {
        var savedCityIDs = self.retrieveStoredCityIDs()
        savedCityIDs.append(cityID)
        defaults.set(savedCityIDs, forKey: citiesIDStorageKey)
    }
    
    func remove(_ cityID: CityID) {
        var savedCityIDs = self.retrieveStoredCityIDs()
        guard let removeIndex = savedCityIDs.firstIndex(of: cityID) else { return }

        savedCityIDs.remove(at: removeIndex)
        defaults.set(savedCityIDs, forKey: citiesIDStorageKey)

    }
}
