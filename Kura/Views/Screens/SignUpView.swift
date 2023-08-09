//
//  SignUpView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 08/08/23.
//

import SwiftUI

struct SignUpView: View {
    
    @State var showOnboarding: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            
            Spacer()
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("You're not signed in!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(colorScheme == .light ? Color.MyTheme.purpleColor : .white)
            
            Text("Sign up now and join the fun community 🥳")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showOnboarding.toggle()
            }, label: {
                Text("Sign in / Sign Up".uppercased())
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .shadow(radius: 12)
            })
            .accentColor(Color.MyTheme.yellowColor)
            
            Spacer()
            
        })
        .padding(.all, 40)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView()
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
