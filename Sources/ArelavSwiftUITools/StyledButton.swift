
import SwiftUI

public struct StyledButton: View {
    public let title: String
    public let systemImage: String
    public let action: () -> Void
    
    public init(title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Spacer()
            Button(action: action, label: {
                Label(title, systemImage: systemImage).padding(5)
            })
            // .padding(5)
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
            Spacer()
        }    
    }
}

struct StyledButton_Previews: PreviewProvider {
    
    static var previews: some View {
        List {
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish")
            })
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish")
            })
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish")
            })
        }.preferredColorScheme(.dark)
        
        List {
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish")
            })
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish")
            })
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish")
            })
        }.preferredColorScheme(.light)
        
    }
}
