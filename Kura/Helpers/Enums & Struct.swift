//
//  Enums & Struct.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 10/08/23.
//

import Foundation

// Fields within the document in database
struct DatabaseUserField {
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let provider = "provider"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
}

// Fields for post data
struct DatabasePostField {
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
    static let likeCount = "like_count" // int
    static let likedBy = "liked_by" // array
    static let comments = "comments" // sub collection
}

// Fields for comments sub collection of a post document in firebase
struct DatabaseCommentsField {
    static let commentID = "comment_id"
    static let displayName = "display_name"
    static let userID = "user_id"
    static let content = "content"
    static let dateCreated = "date_created"
}

// Fields for report data
struct DatabaseReportField {
    static let content = "content"
    static let postID = "post_id"
    static let dateCreated = "date_created"    
}

// Fields for UserDefaults
struct CurrentUserDefaults {
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}
