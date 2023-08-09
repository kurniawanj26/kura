//
//  CommentsView.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/07/23.
//

import SwiftUI

struct CommentsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(commentArray, id: \.self, content: { comment in
                        MessageView(comment: comment)
                    })
                }
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
                .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.white)
            }
            .padding(.all,6)
        }
        .padding(.horizontal)
        .navigationTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            getComments()
        })
    }
    
    // MARK: FUNCTION
    
    func getComments() {
        
        print("GET COMMENTS FROM DB")
        
        let comment1 = CommentModel(commentID: "", userID: "", username: "Zoro", content: "I will pet you", dateCreated: Date())
        let comment2 = CommentModel(commentID: "", userID: "", username: "Sanji", content: "I will feed you", dateCreated: Date())
        
        self.commentArray.append(comment1)
        self.commentArray.append(comment2 )
        
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CommentsView()
        }
    }
}
