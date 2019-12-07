//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import XCTest

class CityDaysModelTests: XCTestCase {

    func test_givenValidCityDaysJsonInput_WhenDecoding_shouldReturnValidCityDaysModels()
    {
        let jsonData = Data("""
        {
            "list": [
                {
                    "dt": 1546300800,
                    "weather": [
                        {
                            "id": 803,
                            "main": "Clouds",
                            "description": "broken clouds",
                            "icon": "04n"
                        }
                    ]
                },
                {
                    "dt": 1553709600,
                    "weather": [
                        {
                            "id": 800,
                            "main": "Clear",
                            "description": "clear sky",
                            "icon": "02n"
                        }
                    ]
                }
            ]
        }
        """.utf8)
        print(" ************* \(jsonData)")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
          do {
            let root: CityDaysList = try decoder.decode(CityDaysList.self, from: jsonData)
              let testedDecodesDays = root.days
              XCTAssertEqual(testedDecodesDays.first?.date, Date(timeIntervalSince1970: 1546300800))
              XCTAssertEqual(testedDecodesDays.first?.weatherItems.first,
                             WeatherInfoItem(description: "broken clouds",
                                             main: "Clouds",
                                             icon: .broken_clouds_n))
              
          } catch {
              XCTFail(error.localizedDescription)
          }
    }
}
