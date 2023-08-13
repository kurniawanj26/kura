//
//  PostArrayObject.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 08/07/23.
//

import Foundation

class PostArrayObject: ObservableObject {
    
    // @Published to create object that will be WATCHED
    @Published var dataArray = [PostModel]()
    
    // var dataArray = [PostModel]() --> to create a blank array of PostModel
    
    init() {
        
        print("FETCH DATA FROM DATABASE")
        
        let post1 = PostModel(postID: "", userID: "", username: "Kuy", caption: "Uiii", dateCreated: Date(), likeCount: 0, likedByOwner: false)
        let post2 = PostModel(postID: "", userID: "", username: "Koy", caption: "Oiii", dateCreated: Date(), likeCount: 0, likedByOwner: false)
        let post3 = PostModel(postID: "", userID: "", username: "Kay", caption: "Aiii", dateCreated: Date(), likeCount: 0, likedByOwner: false)
        let post4 = PostModel(postID: "", userID: "", username: "Key", caption: "Eiii", dateCreated: Date(), likeCount: 0, likedByOwner: false)
        
        self.dataArray.append(post1)
        self.dataArray.append(post2)
        self.dataArray.append(post3)
        self.dataArray.append(post4)
    }
    
    /// USED FOR SINGLE POST SELECTION
    init(post: PostModel) {
        
        self.dataArray.append(post)
        
    }
    
    /// USED FOR GETTING POST FOR USER PROFILE
    init(userID: String) {
        
        print("Get posts for user with ID: \(userID)")
        DataService.instance.downloadPostForUser(userID: userID) { returnePosts in
            let sortedPosts = returnePosts.sorted { post1, post2 in
                return post1.dateCreated > post2.dateCreated
            }
            self.dataArray.append(contentsOf: sortedPosts)
        }
        
    }
}
