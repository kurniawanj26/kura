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
    
    var post: PostModel
    
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName: String?
    
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
                
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                // binding text
                // as the TextField changes the text
                // the $submissinText will changes as well
                TextField("Add a comment...", text: $submissionText)
                
                Button(action: {
                    if textIsAppropriate() {
                        addComment()
                    }
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
            getProfilePicture()
        })
    }
    
    // MARK: FUNCTION
    
    func getProfilePicture() {
        
        guard let userID = currentUserID else { return }
        
        ImageManager.instance.downloadProfileImage(userID: userID) { returnedImage in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
    
    func getComments() {
        
        print("GET COMMENTS FROM DB")
        
        let comment1 = CommentModel(commentID: "", userID: "", username: "Zoro", content: "I will pet you", dateCreated: Date())
        let comment2 = CommentModel(commentID: "", userID: "", username: "Sanji", content: "I will feed you", dateCreated: Date())
        
        self.commentArray.append(comment1)
        self.commentArray.append(comment2 )
        
    }
    
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
    
    func addComment() {
        
        guard let userID = currentUserID, let displayName = currentDisplayName else { return }
        
        DataService.instance.submitComment(postID: post.postID, content: submissionText, displayName: displayName, userID: userID) { success, returnedCommentID in
            
            if success, let commentID = returnedCommentID {
                let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: submissionText, dateCreated: Date())
                self.commentArray.append(newComment)
                self.submissionText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    
    static let post = PostModel(postID: "123", userID: "123", username: "Dummy", dateCreated: Date(), likeCount: 0, likedByOwner: false)
    
    static var previews: some View {
        NavigationView{
            CommentsView(post: post)
        }
    }
}
