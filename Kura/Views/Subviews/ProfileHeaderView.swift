//
//  ProfileHeaderView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 05/08/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            
            // MARK: PROFILE PICTURE
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            // MARK: USERNAME
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // MARK: BIO
            Text("King of the pirates.")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
            
            HStack(alignment: .center, spacing: nil, content: {
                
                // MARK: POSTS
                VStack(alignment: .center, spacing: 5, content:  {
                
                    Text("4")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Post")
                        .font(.callout)
                        .fontWeight(.medium)
                })
                
                // MARK: LIKES
                VStack(alignment: .center, spacing: 5, content:  {
                
                    Text("200")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    
                    Text("Likes")
                        .font(.callout)
                        .fontWeight(.medium)
                })
            })
        })
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    
    @State static var name: String = "Luffy"
    @State static var image: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image)
            .previewLayout(.sizeThatFits)
    }
}
