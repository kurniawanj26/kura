//
//  SettingsEditTextView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 07/08/23.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingEditTextOption: SettingsEditTextOption
    @Binding var profileText: String
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var showSuccessAlert: Bool = false
    
    var body: some View {
        VStack {
            
            HStack {
                Text(description)
                
                Spacer(minLength: 0)
            }
            
            TextField(placeholder, text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
            
            Button(action: {
                if textIsAppropriate() {
                    saveText()
                }
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert) {
            return Alert(title: Text("Saved ✅"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    // MARK: FUNCTIONS
    func textIsAppropriate() -> Bool {
        // check if text has curses or toxic words
        // check if the text is too short
        // check if the text is blank
        
        let badwordArray: [String] = ["shit", "ass", "fuck"]
        
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            if badwordArray.contains(word) {
                return false
            }
        }
        
        if submissionText.count < 4 {
            return false
        }
        
        return true
    }

    func saveText() {
        
        guard let userID = currentUserID else { return }
        
        switch settingEditTextOption {
        case .displayName:
            
            // update the UI on profile view
            self.profileText = submissionText
            
            // update the user default
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.displayName)
            
            // update on all of the user's posts
            DataService.instance.updateDisplayNameOnPosts(userID: userID, displayName: submissionText)
            
            // update on user profile in database
            AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { success in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }

        case .bio:
            
            // update the UI on profile view
            self.profileText = submissionText
            
            // update the user default
            UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
            
            // update on user profile in database
            
            AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { success in
                if success {
                    self.showSuccessAlert.toggle()
                }
            }
        }
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    
    @State static var text: String = ""
    
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(title: "Title", description: "Description", placeholder: "Placeholder", settingEditTextOption: .displayName, profileText: $text)
        }
    }
}
