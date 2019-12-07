//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import XCTest

class CityModelTests: XCTestCase {

    func test_givenValidJsonInput_WhenDecoding_shouldReturnValidCityModel() {
        let jsonData = Data("""
        {
            "weather": [
                {
                    "id": 300,
                    "main": "Drizzle",
                    "description": "light intensity drizzle",
                    "icon": "09d"
                }
            ],
            "id": 2643743,
            "name": "London",
            "cod": 200
        }
        """.utf8)
        let decoder = JSONDecoder()
        do {
            let testedItem: CityModel = try decoder.decode(CityModel.self, from: jsonData)
            XCTAssertEqual(testedItem.id, 2643743)
            XCTAssertEqual(testedItem.name, "London")
            XCTAssertEqual(testedItem.weatherItems.first,
                           WeatherInfoItem(description: "light intensity drizzle",
                                           main: "Drizzle",
                                           icon: .shower_rain_d))
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func test_givenValidCityListJsonInput_WhenDecoding_shouldReturnValidCityModels()
    {
        let jsonData = Data("""
        {
            "cnt": 2,
            "list": [
                {
                    "weather": [
                        {
                            "id": 300,
                            "main": "Drizzle",
                            "description": "light intensity drizzle",
                            "icon": "09d"
                        }
                    ],
                    "id": 2643743,
                    "name": "London"
                },
                {
                    "weather": [
                        {
                            "id": 803,
                            "main": "Clouds",
                            "description": "broken clouds",
                            "icon": "04n"
                        }
                    ],
                    "id": 703448,
                    "name": "Kiev"
                }
            ]
        }
        """.utf8)
        
        let decoder = JSONDecoder()
        do {
            let root: CityModelList = try decoder.decode(CityModelList.self, from: jsonData)
            let testedDecodesCites = root.cities
            XCTAssertEqual(testedDecodesCites.first?.id, 2643743)
            XCTAssertEqual(testedDecodesCites.first?.name, "London")
            XCTAssertEqual(testedDecodesCites.first?.weatherItems.first,
                           WeatherInfoItem(description: "light intensity drizzle",
                                           main: "Drizzle",
                                           icon: .shower_rain_d))
            
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }
}
