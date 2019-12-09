//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation
import os

extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}


class CityNetService: CityNetServing {
    
    private let appid: String
    private let session = URLSession(configuration: .default)
    private var components: URLComponents = URLComponents()
    
    
    
    init(appid:String = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPPID") as? String ?? "CAN'T FIND APPID") {

        self.appid = appid
        
        // FIXME : Most of this values should be read from Info.plist (App Config)
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/group"
        components.queryItems = [
            URLQueryItem(name: "appid", value: appid)
        ]
    }
    
    func load(for citiesIDs: [CityID], handler: @escaping (Result<[CityModel], Error>) -> Void)  {
        
        let citiesIDsCommaSeparated = citiesIDs.map{String($0)}.joined(separator: ",")
        
        components.queryItems?.append(URLQueryItem(name: "id", value: citiesIDsCommaSeparated))
        let url = components.url
        os_log("About to request URL : %{public}s",
        log: OSLog.webServiceCycle,
        type: .info,
        url?.absoluteString ?? "NotValidURL")

        let task = session.dataTask(with: url!){ (result) in
               switch result {
                   case .success(/*let response*/_, let data):

                    let decoder = JSONDecoder()
                    do {
                        let root: CityModelList = try decoder.decode(CityModelList.self, from: data)
                        handler(.success(root.cities))
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
