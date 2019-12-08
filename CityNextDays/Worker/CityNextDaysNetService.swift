//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation
import os

class CityNextDaysNetService: CityNextDaysNetServing {

private let session = URLSession(configuration: .default)
private var components: URLComponents = URLComponents()

    init() {
        // FIXME : Most of this values should be read from Info.plist (App Config)
        // pro.openweathermap.org/data/2.5/forecast/hourly?id=524901
    //api.openweathermap.org/data/2.5/forecast?id=524901&appid=f9bbb84ef43f5efdd851ca475174be39
        components.scheme = "http"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            URLQueryItem(name: "appid", value: "f9bbb84ef43f5efdd851ca475174be39" )
        ]
    }
    
    func load(for cityID: CityID, handler: @escaping (Result<[CityDayModel], Error>) -> Void) {
        components.queryItems?.append(URLQueryItem(name: "id", value: String(cityID)))
        let url = components.url
        os_log("About to request URL : %{public}s",
        log: OSLog.webServiceCycle,
        type: .info,
        url?.absoluteString ?? "NotValidURL")

        let task = session.dataTask(with: url!){ (result) in
               switch result {
                   case .success(/*let response*/_, let data):

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    do {
                        let root: CityDaysList = try decoder.decode(CityDaysList.self, from: data)
                        handler(.success(root.days))
                    } catch {
                        handler(.failure(error))
                    }
                       break
                   case .failure(let error):
                    handler(.failure(error))
                       break
                }
        }
        task.resume()
    }

}
