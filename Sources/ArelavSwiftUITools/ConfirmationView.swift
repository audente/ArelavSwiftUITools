import SwiftUI

public struct ConfirmationView: View {
    @Binding var isPresented: Bool
    
    let systemImage: String
    let title: String
    let confirmation: String
    let detail: String?
    let feature: String?
    let cancelText: String
    let actionText: String
    let action: () -> Void
    
    @State private var runAction = false
    
    public var body: some View {
        VStack {
            Spacer()
            Spacer()
            VStack{
                Image(systemName: systemImage)
                    .imageScale(.large)
                    .font(.system(.largeTitle, design: .default))
                    .fontWeight(.bold)
                Text(title)
                    .font(.system(.largeTitle, design: .default))
                    .fontWeight(.bold)
                    .padding()
                Text(confirmation)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                if let detail {
                    Text(detail)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()                    
                }
                if let feature {
                    Text(feature)
                        .font(.title)
                        .foregroundColor(.accentColor)
                        .fontWeight(.bold)
                        .padding()                    
                }
            }
            Spacer()
            VStack {
                Button(actionText) {
                    isPresented = false
                    runAction = true
                }
                .padding(.bottom, 10)
                .padding(.top, 10)
                .padding(.leading, 60)
                .padding(.trailing, 60)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(30)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Button(cancelText){
                    isPresented = false
                }.padding(.bottom, 20)

            }
        }.onDisappear(perform: {
            if runAction {
                action()
            }
        })
        .presentationDragIndicator(.visible)
        .padding()
    
    }
}


struct ConfirmationView_Previews: PreviewProvider {
    static var bindingValue: Bool = true
    static var binding = Binding(get: { bindingValue }, set: { bindingValue = $0 })

    
    static var previews: some View {
        NavigationStack {
            VStack {
                HStack {
                    Spacer()
                    Toggle("Show", isOn: binding)
                    Spacer()
                }.padding()
            }.padding()
                .navigationTitle("Test")
                .navigationBarTitleDisplayMode(.large)
                .sheet(isPresented: binding) {
                    ConfirmationView(
                        isPresented: binding,
                        systemImage: "cross.case.fill",
                        title: "Confirmation Title", 
                        confirmation: "Confirmation description and detail text for the user\nConfirmation description and detail text for the user", 
                        detail: "Confirmation description and detail text for the user\nConfirmation description and detail text for the user", 
                        feature: "$1,230.00",
                        cancelText: "Cancel",
                        actionText: "Confirm", 
                        action: { print("Confirming") }
                    )
                }
        }
    }
}
