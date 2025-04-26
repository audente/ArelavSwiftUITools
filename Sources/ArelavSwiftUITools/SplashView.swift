//
//  SplashView.swift
//  RTK_Spike
//
//  Created by Jason Cheladyn on 2022/04/04.
//
import SwiftUI

public struct SplashView<V: View>: View {
    var image: Image
    var backColor: Color
    var waitSeconds: Double
    var mainView: () -> V
    
    @State var isActive: Bool = false
    
    public var body: some View {
        ZStack {
            if self.isActive {
                mainView()
                
            } else {
                ZStack {
                    Rectangle()
                        .foregroundColor(backColor)
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }.ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + waitSeconds) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashView(image: Image(systemName: "flag.checkered.2.crossed"), backColor: Color.white, waitSeconds: 1.5) {
                Text("Hello, world!")
            }
            SplashView(image: Image(systemName: "sun.haze.circle"), backColor: Color.blue, waitSeconds: 2.0) {
                Text("Hello, world!")
            }.preferredColorScheme(.dark)
        }
        
    }
}
