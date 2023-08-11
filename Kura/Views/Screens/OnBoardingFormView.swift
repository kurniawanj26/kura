//
//  OnBoardingFormView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 08/08/23.
//

import SwiftUI

struct OnBoardingFormView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Binding var procider: String
    
    @State var showImagePicker: Bool = false
    
    // MARK: IMAGE PICKER
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State var showError: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20, content: {
            
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.MyTheme.beigeColor : .gray)
                .foregroundColor(.black)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.5))
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .light ? Color.MyTheme.purpleColor : .white)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker, onDismiss: createProfile, content: {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        })
        .alert(isPresented: $showError) { () -> Alert in
            return Alert(title: Text("Error creating profile 🥲"))
        }
        
    }
    
    // MARK: FUNCTIONS
    func createProfile() {
        print("CREATING PROFILE")
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerID: providerID, provider: procider, profileImage: imageSelected) { returnedUserID in
            
            if let userID = returnedUserID {
                // SUCCESS
                print("Success created new user in database")
                
                AuthService.instance.logInUserToApp(userID: userID) { success in
                    if success {
                        print("User logged in")
                        
                        // return to app
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } else {
                        print("Error logged in")
                        self.showError.toggle()
                    }
                }
            } else {
                // ERROR
                print("Error creating user in database")
            }
        }
    }
}

struct OnBoardingFormView_Previews: PreviewProvider {
    
    @State static var testString: String = ""
    
    static var previews: some View {
        OnBoardingFormView(displayName: $testString, email: $testString, providerID: $testString, procider: $testString)
    }
}
