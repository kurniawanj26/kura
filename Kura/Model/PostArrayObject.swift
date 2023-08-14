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
    
    /// USED FOR FEED
    init(shuffled: Bool) {
        
        print(" Get posts for feed. Shuffled \(shuffled)")
        DataService.instance.downloadPostsForFeed { returnedPosts in
            if shuffled {
                let shuffledPosts = returnedPosts.shuffled()
                self.dataArray.append(contentsOf: shuffledPosts)
            } else {
                self.dataArray.append(contentsOf: returnedPosts)
            }
        }
        
    }
}
