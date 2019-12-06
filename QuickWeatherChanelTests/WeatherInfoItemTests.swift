//Created by Maxime Wacker on 05/12/2019.
//Copyright © 2019 Max. All rights reserved.

import XCTest
@testable import QuickWeatherChanel

class WeatherInfoItemTests: XCTestCase {

    func test_givenValidJsonInput_WhenDecoding_shouldReturnValidWeatherInfoItem() {
        let jsonData = Data("""
        {
        "id":300,
        "main":"Drizzle",
        "description":"light intensity drizzle",
        "icon":"09d"
        }
        """.utf8)
        let decoder = JSONDecoder()
        do {
            let testedItem: WeatherInfoItem = try decoder.decode(WeatherInfoItem.self, from: jsonData)
            XCTAssertEqual(testedItem.description, "light intensity drizzle")
            XCTAssertEqual(testedItem.icon, .shower_rain_d)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
    }

}
