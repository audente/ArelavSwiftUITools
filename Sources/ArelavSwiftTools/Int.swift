import SwiftUI

public extension Int {
    var localized: String {
        return self.formatted(.number)
    }
}
