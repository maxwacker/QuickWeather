//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.


struct CityModel {
    let id: Int
    let name: String
    let weatherItems: [WeatherInfoItem]
}

extension CityModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case weatherItems = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.weatherItems = try container.decode([WeatherInfoItem].self, forKey: .weatherItems)
    }
}

// This struct just for mapping the JSON response (an a key "list" at root, with an array as value)
struct CityModelList {
    let cities: [CityModel]
}

extension CityModelList: Decodable {
    enum CodingKeys: String, CodingKey {
        case cities = "list"
    }
}
