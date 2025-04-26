import SwiftUI
import ArelavSwiftTools


struct ContentView: View {
    @State var name: String = "World"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, \(name)!")
            Button("Change") {
                name = GetText()
                var logger = Log.shared
                logger.logLevel = .Info
                logger.Debug(msg: "Hi")
            }
        }
    }
}
