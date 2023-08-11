//
//  DataService.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/08/23.
//

// Used to handle uploading and download data (other user) from database
import Foundation
import SwiftUI
import Firebase

class DataService {
    
    // MARK: PROPERTIES
    
    static let instance = DataService()
    
    private var REF_POSTS = DB_BASE.collection("posts")
    
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
}

