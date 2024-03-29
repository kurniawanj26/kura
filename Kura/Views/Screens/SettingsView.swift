//
//  SettingsView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 07/08/23.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var showSignOutError: Bool = false
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false, content: {
                
                // MARK: SECTION 1: KURA
                GroupBox(label: SettingsLabelView(labelText: "Kura", labelImage: "dot.radiowaves.left.and.right"), content: {
                    HStack(alignment: .center, spacing: 10, content: {
                        
                        Image("logo.transparent")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                            .shadow(color: .MyTheme.purpleColor, radius: 5)
                        
                        Text("Kura is the #1 app for posting pictures of your pets. Happy to have you in our community!")
                            .font(.footnote)
                    })
                })
                .padding()
                
                // MARK: SECTION 2: PROFILE
                GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill"), content: {
                    
                    // DISPLAY NAME
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: userDisplayName, title: "Display name", description: "Put your display name here. This will be seen by other user.", placeholder: "Your display name here...", settingEditTextOption: .displayName, profileText: $userDisplayName), label: {
                        SettingsRowView(leftIcon: "pencil", text: "Display Name", color: Color.MyTheme.purpleColor)
                    })
                    
                    // BIO
                    NavigationLink(
                        destination: SettingsEditTextView(submissionText: userBio, title: "Profile Bio", description: "Your bio is a great place to let other user know a little about you. It will be shown on your profile only.", placeholder: "Your bio here...", settingEditTextOption: .bio, profileText: $userBio), label: {
                        SettingsRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                    })
                    
                    // PROFILE PICTURE
                    NavigationLink(
                        destination: SettingsEditImageView(title: "Profile Picture", description: "Your picture picture will be shown on your profile and on your posts.", selectedImage: userProfilePicture, profileImage: $userProfilePicture), label: {
                        SettingsRowView(leftIcon: "photo", text: "Profile Picture", color: Color.MyTheme.purpleColor)
                    })
                    
                    Button(action: {
                        singOut()
                    }, label: {
                        SettingsRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color.MyTheme.purpleColor)
                    })
                    .alert(isPresented: $showSignOutError, content: {
                        return Alert(title: Text("Error signing out"))
                    })
                   
                })
                .padding()
                
                // MARK: SECTION 3: APPLICATION
                GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone"), content: {
                    Button(action: {
                        openCustomURL(urlString: "https://www.google.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.youtube.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Terms & Condition", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button(action: {
                        openCustomURL(urlString: "https://www.yahoo.com")
                    }, label: {
                        SettingsRowView(leftIcon: "folder.fill", text: "Kura's Website", color: Color.MyTheme.yellowColor)
                    })
                })
                .padding()
                
                // MARK: SECTION 4: SIGN OFF
                GroupBox(content: {
                    Text("Kura was made with ❤️ \nAll rights reserved \n \nCopyright 2023")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                })
                .padding()
            })
            .navigationBarTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(leading:
                                    Button(action: {
                                        presentationMode.wrappedValue.dismiss()
            						}, label: {
                                        Image(systemName: "xmark")
                                            .font(.title2)
                                    })
                                        .accentColor(.primary)
            )
        }
        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : .white)
    }
    
    // MARK: FUNCTIONS
    func openCustomURL(urlString: String) {
        guard let url =  URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func singOut() {
        AuthService.instance.logOutUser { success in
            if success {
                print("Successfully logout")
                
                // dismiss settings view
                self.presentationMode.wrappedValue.dismiss()
            } else {
                print("Error logging out")
                self.showSignOutError.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    @State static var testString: String = ""
    @State static var image: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        SettingsView(userDisplayName: $testString, userBio: $testString, userProfilePicture: $image)
    }
}
