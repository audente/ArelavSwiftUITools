import SwiftUI
import ArelavSwiftUITools


struct ContentView: View {
    @State var name: String = "World"
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, \(name)!")
            StyledButton(title: "Share", systemImage: "icloud.and.arrow.up", action: {
                print(" » Publish: \(Bundle.main.bundleIdentifier ?? "<Empty>")")
            })
            
        }
    }
}
