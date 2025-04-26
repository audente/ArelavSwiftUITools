//
//  File.swift
//  
//
//  Created by Juan Valera on 22/06/20.
//

import Foundation

public extension Encodable {
    var jsonString : String {
        get {
            return String(data: (try? JSONEncoder().encode(self)) ?? Data(), encoding: .utf8) ?? ""
        }
    }
}

public extension Decodable {
    static func decode(from json: String) throws -> Self  {
        return try JSONDecoder().decode(Self.self, from: json.data(using: .utf8) ?? Data())
    }
}
