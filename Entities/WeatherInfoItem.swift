//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation

// From https://openweathermap.org/weather-conditions
enum WeatherIcon: String {
    case clear_sky_d = "01d"
    case few_clouds_d = "02d"
    case scattered_clouds_d = "03d"
    case broken_clouds_d = "04d"
    case shower_rain_d = "09d"
    case rain_d = "10d"
    case thunderstorm_d = "11d"
    case snow_d = "13d"
    case mist_d = "50d"
    case clear_sky_n = "01n"
    case few_cloud_n = "02n"
    case scattered_clouds_n = "03n"
    case broken_clouds_n = "04n"
    case shower_rain_n = "09n"
    case rain_n = "10n"
    case thunderstorm_n = "11n"
    case snow_n = "13n"
    case mist_n = "50n"
    
    case _unknown_ = "unknown_WeatherIcon"
    
}

extension WeatherIcon: Decodable {
    init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        self = WeatherIcon(rawValue: label) ?? ._unknown_
    }
}

struct WeatherInfoItem {
    let description: String
    let main: String
    let icon: WeatherIcon
}

extension WeatherInfoItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case description, main, icon
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.description = try container.decode(String.self, forKey: .description)
        self.main = try container.decode(String.self, forKey: .main)
        self.icon = try container.decode(WeatherIcon.self, forKey: .icon)
    }
}

