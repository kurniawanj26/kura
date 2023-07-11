//
//  CommentsView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/07/23.
//

import SwiftUI

struct CommentsView: View {
    
    @State var submissionText: String = ""
    
    var body: some View {
        VStack {
            
            ScrollView {
                Text("Placeholder")
                Text("Placeholder")
                Text("Placeholder")
                Text("Placeholder")
            }
            
            HStack {
                
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                // binding text
                // as the TextField changes the text
                // the $submissinText will changes as well
                TextField("Add a comment...", text: $submissionText)
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                })
                .accentColor(Color.MyTheme.blueColor)
            }
            .padding(.all,6)
        }
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CommentsView()
        }
    }
}
