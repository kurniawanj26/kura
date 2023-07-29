//
//  PostModel.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 07/05/23.
//

import Foundation
import SwiftUI

// Identifiable : https://developer.apple.com/documentation/swift/identifiable
// Hashable : https://developer.apple.com/documentation/swift/hashable
struct PostModel: Identifiable, Hashable {
    
    var id = UUID()
    var postID: String // ID for the post in db
    var userID: String // ID for the user in db
    var username: String // username of user in db
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByOwner: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    
}
