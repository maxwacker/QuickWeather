//Created by Maxime Wacker on 07/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation
import os

class CityNextDaysNetService: CityNextDaysNetServing {
    private let appid: String
    private let session = URLSession(configuration: .default)
    private var components: URLComponents = URLComponents()

    init(appid:String = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPPID") as? String ?? "CAN'T FIND APPID") {
        
        self.appid = appid
        
        // FIXME : Most of this values should be read from Info.plist (App Config)
        components.scheme = "http"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            URLQueryItem(name: "appid", value: appid)
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
                    os_log("Decoding Failure for  ",
                    log: OSLog.cityDayCaseCycle,
                    type: .error,
                    url?.absoluteString ?? "NotValidURL")
                    handler(.failure(error))
                       break
                }
        }
        task.resume()
    }

}
