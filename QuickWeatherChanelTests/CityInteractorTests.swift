//Created by Maxime Wacker on 09/12/2019.
//Copyright © 2019 Max. All rights reserved.

import XCTest
@testable import QuickWeatherChanel


let weatherItem1 = WeatherInfoItem(description: "w1", main: "m1", icon: WeatherIcon.snow_d)

let weatherItem2 = WeatherInfoItem(description: "w1", main: "m1", icon: WeatherIcon.mist_n)


let someFakeCityModels = [
    CityModel(id: 1, name: "Paris", weatherItems: [weatherItem1]),
    CityModel(id: 2, name: "cityName1", weatherItems: [weatherItem1])
]

class FakeCityNetService: CityNetServing {
    var loadCityCalledWithValue: String?
    func load(for citiesIDs: [CityID], handler: @escaping (Result<[CityModel], Error>) -> Void) {
        handler(.success(someFakeCityModels))
    }
    
    func loadCity(named name: String, handler: @escaping (Result<CityModel, Error>) -> Void) {
        self.loadCityCalledWithValue = name
        handler(.success(someFakeCityModels.first!))
    }
}

class FakeCityRouter: CityRouting {
    var requestCityNextdaysScreenCalledWithValue: CityID?
    var requestCityAddCalled: Bool?
    
    func requestCityNextdaysScreen(for cityID: Int) {
        self.requestCityNextdaysScreenCalledWithValue = cityID
    }
    func requestCityAdd(handler: @escaping (String) -> Void) {
        self.requestCityAddCalled = true
        handler("Paris")
    }
}

class FakeCityStorage: CityStoring {
    
    var savedCityIDs = [1, 2]
    
    func retrieveStoredCityIDs() -> [CityID] {
        return savedCityIDs
    }
    
    func store(_ cityID: CityID) {
        savedCityIDs.append(cityID)
    }
 
    func remove(_ cityID: CityID) {
        if let removeIndex = savedCityIDs.firstIndex(of: cityID) {
            savedCityIDs.remove(at: removeIndex)
        }
    }
}

class CityInteractorTests: XCTestCase {
    
    
    let netService = FakeCityNetService()
    let storage = FakeCityStorage()
    let router = FakeCityRouter()
    var testedInteractor: CityInteractor?
    
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        testedInteractor = CityInteractor(netService: netService, storage: storage, router: router)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GivenSomeStoredCityIDStored_WhenLoadInvoked_ShouldReturnCellViewModels() {
        testedInteractor?.loadCities { cityModelsResult in
            switch cityModelsResult {
            case .success( let cityModels):
                XCTAssertEqual(cityModels.count, 2)
                XCTAssertEqual(cityModels[0].id, 1)
                XCTAssertEqual(cityModels[1].id, 2)

            case .failure(_):
                break
            }
        }
    }
    
    func test_GivenIntractorSetUp_WhenRequestCityNextdaysScreenInvoked_ShouldInvokeRouterWithSameID() {
        testedInteractor?.requestCityNextdaysScreen(for: 1)
        XCTAssertEqual(router.requestCityNextdaysScreenCalledWithValue, 1)
    }

    func test_GivenInteractorSetup_WhenRequestCityAddInvoked_ShouldInvokeRouterCityAdd_LoadCityService_StoreCityID() {
        testedInteractor?.requestCityAdd { voidResult in
            switch voidResult {
                case .success(_):
                    XCTAssertTrue(self.router.requestCityAddCalled!)
                    XCTAssertEqual(self.netService.loadCityCalledWithValue, "Paris")
                    XCTAssertEqual(self.storage.savedCityIDs.count, 3)
                case .failure(_):
                    break
            }
        }
    }
 
    func test_GivenInteractorSetup_WhenRequestCityRemoveInvoked_ShouldInvokeRemoveCityID_AndReturnReducedViewModel() {
        testedInteractor?.requestCityRemove(cityID: 2) { cellviewModels in
            XCTAssertEqual(cellviewModels.count, 2)
            }
        }
    

    
}
