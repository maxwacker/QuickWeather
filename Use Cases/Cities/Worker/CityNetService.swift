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

    private let session = URLSession(configuration: .default)
    // FIXME : Most of this values should be read from Info.plist (App Config)
    private let scheme = "https"
    private let host = "api.openweathermap.org"
    private let appid = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAPPID") as? String ?? "CAN'T FIND APPID"
    
    private func commonComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.queryItems = [
            URLQueryItem(name: "appid", value: appid)
        ]
        return components
    }
    
    func load(for citiesIDs: [CityID], handler: @escaping (Result<[CityModel], Error>) -> Void)  {
        guard !citiesIDs.isEmpty else {
            handler(.success([CityModel]()))
            return
        }
        let citiesIDsCommaSeparated = citiesIDs.map{String($0)}.joined(separator: ",")

        var components = commonComponents()
        components.path = "/data/2.5/group"
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
    
    func loadCity(named name: String, handler: @escaping (Result<CityModel, Error>) -> Void) {
        var components = commonComponents()
        components.path = "/data/2.5/weather"
        components.queryItems?.append(URLQueryItem(name: "q", value: name))
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
                        let root: CityModel = try decoder.decode(CityModel.self, from: data)
                        handler(.success(root))
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
