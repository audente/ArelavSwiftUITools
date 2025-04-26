import Foundation


// ------------------------------------------------------------------

public struct ErrorObject: Decodable {
    let id: String?
    let message: String
}

public enum RequestMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}


public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case statusCode(String)
    case unknown(String)
    
    var customMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .decode:
            return "Decode error"
        case .noResponse:
            return "No response received"
        case .unauthorized:
            return "Invalid session"
        case .statusCode(let message):
            return message
        case .unknown(let errorStr):
            return "Unexpected Networking Error: \(errorStr)"
        }
    }
}


// ------------------------------------------------------------------

public enum Stage {
    case UAT
    case PROD
    
    var path: String { 
        switch self {
        case .UAT:
            return "/UAT"
        case .PROD:
            return ""
        }
    }
}

public protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var header: [String: String]? { get }    
    var path: String { get }
    var method: RequestMethod { get }
    var body: Encodable? { get }
    var multipart: MultipartRequest? { get }
}


public extension Endpoint {
    var header: [String: String]?  { nil }
    var body: Encodable? { nil }
    var multipart: MultipartRequest? { nil }
    
    var request: URLRequest? {
        get {
            var urlComponents = URLComponents()
            urlComponents.scheme = scheme
            urlComponents.host = host
            urlComponents.path = path
            
            guard let url = urlComponents.url else {
                return nil
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            Log.shared.Debug(msg: "Method", detail: String(describing: request.httpMethod ?? ""))
            request.allHTTPHeaderFields = header
            Log.shared.Debug(msg: "Headers", detail: String(describing: request.allHTTPHeaderFields ?? [:]))

            if let body {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                encoder.keyEncodingStrategy = .convertToSnakeCase
                let data: Data = (try? encoder.encode(body)) ?? Data()
                Log.shared.Debug(msg: "Body", detail: String(data: data, encoding: .utf8))
                request.httpBody = data
                request.allHTTPHeaderFields?["Content-Type"] = "application/json"
                Log.shared.Debug(msg: "JSON Header", detail: String(describing: request.allHTTPHeaderFields))
            } else if let multipart {
                request.allHTTPHeaderFields?["Content-Type"] = multipart.httpContentTypeHeadeValue
                Log.shared.Debug(msg: "Multipart Headers", detail: String(describing: request.allHTTPHeaderFields))
                request.httpBody = multipart.httpBody
            }
            
            Log.shared.Debug(msg: "Request", detail: String(describing: request))
            return request
        }
        
    }
}


// ------------------------------------------------------------------

public protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError>
}


public extension HTTPClient {
    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        
        guard let request = endpoint.request else {
            return .failure(.invalidURL)            
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            Log.shared.Debug(msg: "Data", detail: String(data: data, encoding: .utf8))
            Log.shared.Debug(msg: "Detail", detail: String(describing: response))


            switch response.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Date.formatterRFC3339)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let decodedResponse = try? decoder.decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                var errorStr = String(data: data, encoding: .utf8) ?? ""
                if let errorObj = try? JSONDecoder().decode(ErrorObject.self, from: data) {
                    errorStr = "\(errorObj.message)\n(\(errorObj.id ?? "No ID"))"
                }
                Log.shared.Debug(msg: "HTTP Error \(response.statusCode)", detail: "\(response)")
                return .failure(.statusCode("\(HTTPURLResponse.localizedString(forStatusCode: response.statusCode).capitalized)\n \(errorStr)"))
            }
        } catch {
            Log.shared.Debug(msg: "Request Error", detail: error.localizedDescription)
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    func stream<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type, 
        prefix: String? = nil,
        suffix: String? = nil
    ) async throws -> AsyncThrowingStream<T, Error> {
        
        guard let request = endpoint.request else {
            Log.shared.Error(msg: "Invalid URL", detail: endpoint.path.description)
            throw RequestError.invalidURL
        }
        
            let (data, response) = try await URLSession.shared.bytes(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            Log.shared.Debug(msg: "Detail", detail: String(describing: response))
            
            switch response.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                return AsyncThrowingStream<T, Error> { continuation in
                    Task(priority: .userInitiated) { 
                        do {
                            for try await line in data.lines {
                                var newLine = line
                                if let prefix, newLine.hasPrefix(prefix) {
                                    newLine = String(newLine.dropFirst(prefix.count))
                                }
                                if let suffix, newLine.hasSuffix(suffix) {
                                    newLine = String(newLine.dropLast(suffix.count)) 
                                }

                                if 
                                    let message = newLine.data(using: .utf8), 
                                    let response = try? decoder.decode(responseModel, from: message) 
                                {
                                        Log.shared.Debug(msg: "Decoded", detail: "\(line)")
                                        continuation.yield(response)
                                } else {
                                    Log.shared.Debug(msg: "Ignored", detail: "\(line)")
                                }
                            }
                            continuation.finish()
                        } catch {
                            continuation.finish(throwing: RequestError.unknown(error.localizedDescription))
                        }
                    }
                }
                
            case 401:
                throw RequestError.unauthorized
                
            default:
                var errorMessage = ""
                for try await line in data.lines {
                    errorMessage += line
                }
                
                Log.shared.Debug(msg: "HTTP Error \(response.statusCode)", detail: "\(errorMessage)")
                throw RequestError.statusCode("\(HTTPURLResponse.localizedString(forStatusCode: response.statusCode).capitalized) | \(errorMessage)")
            }
        
    }
}


// ------------------------------------------------------------------

