//
//  OnboardingView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 08/08/23.
//

import SwiftUI
import FirebaseAuth

struct OnboardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingFormView: Bool = false
    @State var showError: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
            
            Text("Welcome to Kura")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            
            Text("Kura is the #1 app for posting pictures of your pets. Happy to have you in our community!")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .light ? Color.MyTheme.purpleColor : .white)
                .padding()
            
            // SIGN IN WITH APPLE
            Button(action: {
                showOnboardingFormView.toggle()
            }, label: {
                SignInWithAppleButtonCustom()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            })
            
            // SIGN IN WITH GOOGLE
            Button(action: {
                SignInWithGoogle.instance.startSignInWithGoogleFlow(view: self)
            }, label: {
                HStack {
                    
                    Image(systemName: "globe")
                    
                    Text("Sign in with Google")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                .cornerRadius(6)
                .font(.system(size: 23, weight: .medium, design: .default))
            })
            .accentColor(Color.white)
            
            // GUEST
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
            })
            .accentColor(.black)
        }
        .padding(.all, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboardingFormView, content: {
            OnBoardingFormView()
        })
        .alert(isPresented: $showError, content: {
            return Alert(title: Text("Error signing in"))
        })
    }
    
    // MARK: FUNCTIONS
    
    func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
        
        AuthService.instance.logInUserToFirebase(credential: credential) { returnedProviderID, isError in
                
            if let providerID = returnedProviderID, !isError {
                
            } else {
                print("Error getting info from log in to Firebase")
                self.showError.toggle()
            }
            
        }
        
    }
        
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
