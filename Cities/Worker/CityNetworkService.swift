//Created by Maxime Wacker on 06/12/2019.
//Copyright © 2019 Max. All rights reserved.

import Foundation

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


struct CityNetworkService {

    private let session = URLSession(configuration: .default)
    private let appid = "&appid=b6907d289e10d714a6e88b30761fae22"
    private var components: URLComponents = URLComponents()
    
    
    
    init() {
       components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/group"
        components.queryItems = [
//            URLQueryItem(name: "id", value: "2643743,524901,703448"),// FIX ME : To be stored in UserDefaults
            URLQueryItem(name: "appid", value: "f9bbb84ef43f5efdd851ca475174be39" ) // FIXME : To be read from Info.plist
        ]
    }
    
    mutating func load(for citiesIDs: [Int], handler: @escaping (Result<[CityModel], Error>) -> Void)  {
        let citiesIDsCommaSeparated = citiesIDs.map{String($0)}.joined(separator: ",")
        components.queryItems?.append(URLQueryItem(name: "id", value: citiesIDsCommaSeparated))
        let url = components.url
        let task = session.dataTask(with: url!){ (result) in
               switch result {
                   case .success(/*let response*/_, let data):

                    let decoder = JSONDecoder()
                    do {
                        let root: CityModelList = try decoder.decode(CityModelList.self, from: data)
                        handler(.success(root.cities))
                        //print("\(city.weaterItems.first?.description)")
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
