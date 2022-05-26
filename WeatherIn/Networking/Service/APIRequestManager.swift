import Foundation

protocol APIRequestProtocol {
    static func makeRequest<T: Codable>(session: URLSession, request: URLRequest, model: T.Type, onCompletion: @escaping(T?, String?) -> ())
    static func makeGetRequest<T: Codable> (type: TypeRequest , coordinates: Parameters, onCompletion: @escaping(T?, String?) -> ())
    static func makeGetImage(name: String, onCompletion: @escaping(Data?,Error?) -> ())
}

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum TypeRequest {
    case current
    case fiveDays
}

enum APIRequestManager: APIRequestProtocol,EndPointType {
    
    case getAPIWeather(type: TypeRequest ,coordinates: Parameters)
    case getImage(name: String)
    
    var apiKeyWeather: String {
        switch self {
        default:
            return "81c0ddde4f4781d0525d8fdf1c1683d4"
        }
    }
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseURL: String {
        switch self {
        case .getAPIWeather:
            return "api.openweathermap.org"
        case .getImage:
            return "openweathermap.org"
        }
    }
    
    var path: String {
        switch self {
        case .getAPIWeather(let type, _):
            switch type {
            case .current:
                return "/data/2.5/weather"
            case .fiveDays:
                return "/data/2.5/forecast"
            }
        case .getImage(let name):
            return "/img/wn/"+"\(name)"+"@2x.png"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAPIWeather, .getImage:
            return .get
        }
    }
    
    var systemAdditionalParameters: Parameters {
        switch self {
        case .getAPIWeather(let type, _):
            switch type {
            case .current,.fiveDays:
                return ["appid": apiKeyWeather,
                        "units": "metric"]
            }
        case .getImage:
            return [:]
        }
    }
    
    /// Generic GET Request
    static func makeGetRequest<T: Codable> (type: TypeRequest ,coordinates: Parameters, onCompletion: @escaping(T?, String?) -> ()) {
        let session = URLSession.shared
        do {
            let request = try Self.getAPIWeather(type: type, coordinates: coordinates).asURLRequest()
            makeRequest(session: session, request: request, model: T.self) { (result, error) in
                onCompletion(result, error)
            }
        } catch {
            onCompletion(nil, NetworkResponse.failed.rawValue)
        }
    }
    /// This function calls the URLRequest passed to it, maps the result and returns it. It is called by GET and POST.
    static func makeRequest<T: Codable>(session: URLSession, request: URLRequest, model: T.Type, onCompletion: @escaping(T?, String?) -> ()) {
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                onCompletion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response: response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        onCompletion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
                        onCompletion(apiResponse,nil)
                    }catch {
                        onCompletion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    onCompletion(nil, networkFailureError)
                }
            }
        }.resume()
    }
    
    static func makeGetImage(name: String, onCompletion: @escaping(Data?,Error?) -> ()) {
        let session = URLSession.shared
        do {
            let request = try Self.getImage(name: name).asURLRequest()
            guard let url = request.url else { return }
            session.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                onCompletion(data,error)
            }).resume()
        } catch {
            onCompletion(nil, error)
        }
    }
    
    fileprivate func asURLRequest() throws -> URLRequest {
        var urlRequest = try URLComponentsCollect()
        var parameters = Parameters()
        switch self {
        case .getAPIWeather(_ , let queries):
            /// we are just going through all the key and value pairs in the queries and adding the same to parameters.. For Each Key-Value pair,  parameters[key] = value
            parameters = mergParametrs(left: queries, right: systemAdditionalParameters)
            URLEncoding.queryString.encode(&urlRequest, with: parameters)
        case .getImage:
            return urlRequest
        }
        return urlRequest
    }
    
    fileprivate func URLComponentsCollect() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = baseURL
        components.path = path
        guard let url = components.url else { throw NetworkError.missingURL }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
    
    fileprivate func mergParametrs<K, V>(left: [K: V], right: [K: V]) -> [K: V] {
        return left.merging(right) { $1 }
    }
}
