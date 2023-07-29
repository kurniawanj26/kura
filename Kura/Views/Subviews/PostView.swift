//
//  PostView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 20/02/23.
//

import SwiftUI

struct PostView: View {
    
    @State var post: PostModel
    var showHeaderAndFooter: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            // MARK: HEADER
            if showHeaderAndFooter {
                HStack {
                    Image("dog1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30, alignment: .center)
                        .cornerRadius(15)
                    
                    Text(post.username)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "ellipsis")
                        .font(.headline)
                }
                .padding(.all,6)
            }
            
            // MARK: IMAGE
            Image("dog2")
                .resizable()
                .scaledToFit()
            
            // MARK: FOOTER
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20, content: {
                    
                    Image(systemName: "heart")
                        .font(.title3)
                    
                    // MARK: COMMENT ICON
                    NavigationLink(destination: CommentsView(), label:  {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                        })
                   
                    
                    Image(systemName: "paperplane")
                        .font(.title3)
                    
                    Spacer()
                })
                .padding(.all,6)
                
                // need to check first
                // because in the PostModel
                // caption is optional
                if let caption = post.caption {
                    HStack {
                        Text(caption)
                        
                        // if the caption as big as the screen width, set the spacer to 0
                        // else it will default to certain amount
                        Spacer(minLength: 0)
                    }
                    .padding(.all,6)
                }
            }
        })
    }
}

struct PostView_Previews: PreviewProvider {
    
    static var post: PostModel = PostModel(postID: "", userID: "", username: "Kuy", caption: "My first post!", dateCreated: Date(), likeCount: 0, likedByOwner: false)
    
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true)
            .previewLayout(.sizeThatFits)
    }
}
