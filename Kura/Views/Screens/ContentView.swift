//
//  ContentView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 19/02/23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName: String?
    
    // String? means it's optional
    // var currentUserID: String? = nil
    
    var body: some View {
        TabView {
            NavigationView {
                FeedView(posts: PostArrayObject(), title: "Feed")
            }
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Feed")
                }
            
            NavigationView {
                BrowseView()
            }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Browse")
                }
            
            UploadView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Upload")
                }
            
            // it's like the conditional render in RN
            ZStack {
                if let userID = currentUserID , let displayName = currentDisplayName {
                    NavigationView {
                        ProfileView(isMyProfile: true, profileUserID: userID, profileDisplayName: displayName)
                    }
                } else {
                    SignUpView()
                }
               
            }
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        // set the icon and text color using colorset in Assets
        // use the extensions from Helpers
        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
