//
//  SettingsEditImageView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 07/08/23.
//

import SwiftUI

struct SettingsEditImageView: View {
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage // image shown in this screen
    @Binding var profileImage: UIImage // image shown on the profile view
    @State var showImagePicker: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    @State var showSuccessAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            HStack {
                Text(description)
                
                Spacer(minLength: 0)
            }
            
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
                .cornerRadius(12)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Import".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
            })
            
            Button(action: {
                saveImage()
            }, label: {
                Text("Save".uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.yellowColor)
            
            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert) {
            return Alert(title: Text("Image Saved ✅"), message: nil, dismissButton: .default(Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    // MARK: FUNCTIONS
    
    func saveImage() {
        
        guard let userID = currentUserID else { return }
        
        // update the UI of the profile
        self.profileImage = selectedImage
        
        // update profile image in database
        ImageManager.instance.uploadProfileImage(userID: userID, image: selectedImage)
        
        // show alert
        self.showSuccessAlert.toggle()
    }
}

struct SettingsEditImageView_Previews: PreviewProvider {
    
    @State static var image: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        NavigationView {
            SettingsEditImageView(title: "Title", description: "Decription", selectedImage: UIImage(named: "dog1")!, profileImage: $image)
        }
    }
}
