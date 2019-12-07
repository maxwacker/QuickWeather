//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation


class CityNextDaysNetService: CityNextDaysNetServing {

private let session = URLSession(configuration: .default)
private var components: URLComponents = URLComponents()

    init() {
        // FIXME : Most of this values should be read from Info.plist (App Config)
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = ""
        components.queryItems = [
            URLQueryItem(name: "appid", value: "f9bbb84ef43f5efdd851ca475174be39" )
        ]
    }
    
    func load(for cityID: CityID, handler: @escaping (Result<[CityDaysModel], Error>) -> Void) {
        
    }

}
