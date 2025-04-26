import Foundation

extension String: @retroactive LocalizedError {
    public var errorDescription: String? { return self }
}

public extension String {
    func unscramble(key: String) -> String {
        guard let data = Data(base64Encoded: self) else { return "" }
        guard let string = String(data: data, encoding: .utf8) else { return "" }
        let key = Array(key)
        
        return String(string.enumerated().map { (i, c) in
            let k = key[i % key.count]                                                        
            guard let cValue = c.asciiValue, let kValue = k.asciiValue else { return c }
            return Character(UnicodeScalar(UInt8(cValue) ^ UInt8(kValue)))
        })  
    }
}

