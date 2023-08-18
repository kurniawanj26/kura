//
//  ProfileView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 05/08/23.
//

import SwiftUI

struct ProfileView: View {
    
    var isMyProfile: Bool
    var profileUserID: String
    var posts: PostArrayObject
    
    @State var profileDisplayName: String
    @State var showSettings: Bool = false
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var profileBio: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, profileBio: $profileBio, postArray: posts)
            
            Divider()
            
            ImageGridView(posts: posts)
        })
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
                                Button(action: {
                                    showSettings.toggle()
                                }, label: {
                                    Image(systemName: "line.horizontal.3")
                                })
                                    .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : .white)
                                .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .onAppear(perform: {
            getProfileImage()
            getAdditionalProfileInfo()
        })
        .sheet(isPresented: $showSettings, content: {
            SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
                .preferredColorScheme(colorScheme)
        })
    }
    
    // MARK: FUNCTIONS
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: profileUserID) { returnedImage in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
    }
    
    func getAdditionalProfileInfo() {
        AuthService.instance.getUserInfo(forUserID: profileUserID) { returnedName, returnedBio in
            if let displayName = returnedName {
                self.profileDisplayName = displayName
            }
            
            if let bio = returnedBio {
                self.profileBio = bio
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileUserID: "", posts: PostArrayObject(userID: ""), profileDisplayName: "Luffy")
        }
    }
}
