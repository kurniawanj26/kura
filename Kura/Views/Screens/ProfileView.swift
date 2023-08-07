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
    var posts = PostArrayObject()
    
    @State var profileDisplayName: String
    @State var showSettings: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            ProfileHeaderView(profileDisplayName: $profileDisplayName)
            
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
                                .accentColor(Color.MyTheme.purpleColor)
                                .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .sheet(isPresented: $showSettings, content: {
            SettingsView()
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView(isMyProfile: true, profileUserID: "", profileDisplayName: "Luffy")
        }
    }
}
