//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import XCTest

class CityModelTests: XCTestCase {

    func test_givenValidJsonInput_WhenDecoding_shouldReturnValidCityModel() {
        let jsonData = Data("""
        {
            "coord": {
                "lon": -0.13,
                "lat": 51.51
            },
            "weather": [
                {
                    "id": 300,
                    "main": "Drizzle",
                    "description": "light intensity drizzle",
                    "icon": "09d"
                }
            ],
            "base": "stations",
            "main": {
                "temp": 280.32,
                "pressure": 1012,
                "humidity": 81,
                "temp_min": 279.15,
                "temp_max": 281.15
            },
            "visibility": 10000,
            "wind": {
                "speed": 4.1,
                "deg": 80
            },
            "clouds": {
                "all": 90
            },
            "dt": 1485789600,
            "sys": {
                "type": 1,
                "id": 5091,
                "message": 0.0103,
                "country": "GB",
                "sunrise": 1485762037,
                "sunset": 1485794875
            },
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
}
