//
//  PostView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 20/02/23.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            
            // MARK: HEADER
            HStack {
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30, alignment: .center)
                    .cornerRadius(15)
                
                Text("User name here")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .font(.headline)
            }
            .padding(.all,6)
            
            // MARK: IMAGE
            Image("dog1")
                .resizable()
                .scaledToFit()
            
            // MARK: FOOTER
            HStack(alignment: .center, spacing: 20, content: {
                
                Image(systemName: "heart")
                    .font(.title3)
                
                Image(systemName: "bubble.middle.bottom")
                    .font(.title3)
                
                Image(systemName: "paperplane")
                    .font(.title3)
                
                Spacer()
            })
            .padding(.all,6)
            
            HStack {
                Text("Caption for the photo")
                
                // if the caption as big as the screen width, set the spacer to 0
                // else it will default to certain amount
                Spacer(minLength: 0)
            }
            .padding(.all,6)
            
        })
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
            .previewLayout(.sizeThatFits)
    }
}
