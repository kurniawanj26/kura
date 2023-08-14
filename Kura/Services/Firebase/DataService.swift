//
//  DataService.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/08/23.
//

// Used to handle uploading and download data (other user) from database
import Foundation
import SwiftUI
import FirebaseFirestore

class DataService {
    
    // MARK: PROPERTIES
    
    static let instance = DataService()
    
    private var REF_POSTS = DB_BASE.collection("posts")
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    // MARK: CREATE FUNCTION
    
    func uploadost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        // create new post document
        
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        // upload image to storage
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { success in
            
            if success {
                // successfully uploaded post to storage
                // then continue to upload post data (caption, displayName, userID) to database
                
                let postData: [String: Any] = [
                    DatabasePostField.postID : postID,
                    DatabasePostField.userID : userID,
                    DatabasePostField.displayName : displayName,
                    DatabasePostField.caption : caption,
                    DatabasePostField.dateCreated : FieldValue.serverTimestamp()
                ]
                
                document.setData(postData) { error in
                    if let error {
                        print("Error uploading data to post document. \(error)")
                        handler(false)
                        return
                    } else {
                        handler(true)
                        return
                    }
                }
                
            } else {
                print("Error uploading post image to Firebase")
                handler(false)
                return
            }
        }
        
    }
    
    // MARK: GET FUNCTIONS
    
    func downloadPostForUser(userID: String, handler: @escaping(_ posts: [PostModel]) ->()) {
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments { querySnapshot, error in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    func downloadPostsForFeed(handler: @escaping (_ posts: [PostModel]) -> ()) {
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 10).getDocuments { querySnapshot, error in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getPostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] {
        
        var postArray = [PostModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                if
                    let userID = document.get(DatabasePostField.userID) as? String,
                    let displayName = document.get(DatabasePostField.displayName) as? String,
                    let timestamp = document.get(DatabasePostField.dateCreated) as? Timestamp {
                    
                    let caption = document.get(DatabasePostField.caption) as? String
                    let date = timestamp.dateValue()
                    let postID = document.documentID
                    
                    let likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0
                    
                    var likedByOwner: Bool = false
                    if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let userID = currentUserID {
                        likedByOwner = userIDArray.contains(userID)
                    }
                    
                    let newPost = PostModel(postID: postID, userID: userID, username: displayName, caption: caption, dateCreated: date, likeCount: likeCount, likedByOwner: likedByOwner)
                    
                    postArray.append(newPost)
                }
            }
            
            return postArray
        } else {
            print("No document found in snapshot for this user")
            return postArray
        }
    }
    
    // MARK: UPDATE FUNCTIONS
 
    func likePost(postID: String, currentUserID: String) {
        
        // update the post count
        // update the array of users who liked the post
        
        let increment: Int64 = 1
        let data: [String: Any] = [
            DatabasePostField.likeCount: FieldValue.increment(increment),
            DatabasePostField.likedBy: FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String) {
        
        // update the post count
        // update the array of users who liked the post
        
        let increment: Int64 = -1
        let data: [String: Any] = [
            DatabasePostField.likeCount: FieldValue.increment(increment),
            DatabasePostField.likedBy: FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
    
}

