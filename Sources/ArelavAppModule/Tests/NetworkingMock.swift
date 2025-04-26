import Foundation
import ArelavSwiftTools

// ------------------------------------------------------------------

struct MockAPIEcho: Codable, Identifiable {
    var id: String
    let createdAt: String
    let name: String
}

// ------------------------------------------------------------------

enum MockAPIEndpoints {
    case echo
    case echoID(Int)    
}


extension MockAPIEndpoints: Endpoint {
    var scheme: String { "https" }
    var host: String { "63be193e585bedcb36a787aa.mockapi.io" }
    var header: [String: String]? { nil }
    
    var path: String {
        switch self {
        case .echo:
            return "/api/echo"
        case .echoID(let id):
            return "/api/echo/\(id)"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .echo, .echoID:
            return .get
        }
    }
    
    var body: Encodable? {
        switch self {
        case .echo, .echoID:
            return nil
        }
    }

}

// ------------------------------------------------------------------

protocol MockAPIServicesProtocol {
    func getUsers() async -> Result<[MockAPIEcho], RequestError>
}

struct MockAPIServices: MockAPIServicesProtocol, HTTPClient {
    
    func getUsers() async -> Result<[MockAPIEcho], RequestError> {
        return await sendRequest(
            endpoint: MockAPIEndpoints.echo, 
            responseModel: [MockAPIEcho].self
        )
    }
    
    func getUser(id: Int) async -> Result<MockAPIEcho, RequestError> {
        return await sendRequest(
            endpoint: MockAPIEndpoints.echoID(id), 
            responseModel: MockAPIEcho.self
        )
    }
}

// ------------------------------------------------------------------

