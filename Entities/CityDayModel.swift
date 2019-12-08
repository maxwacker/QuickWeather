//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation

struct CityDayModel {
    let date: Date
    let weatherItems: [WeatherInfoItem]
}

extension CityDayModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weatherItems = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.weatherItems = try container.decode([WeatherInfoItem].self, forKey: .weatherItems)
    }
}

// This struct just for mapping the JSON response (a key "list" at root, with an array as value)

struct CityDaysList {
    let days: [CityDayModel]
}

extension CityDaysList: Decodable {
    enum CodingKeys: String, CodingKey {
        case days = "list"
    }
}

struct CityDaysWeathersList {
    let weathers: [WeatherInfoItem]
}

extension CityDaysWeathersList: Decodable {
    enum CodingKeys: String, CodingKey {
        case weathers
    }
}
