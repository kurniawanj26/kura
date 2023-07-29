//
//  CommentModel.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/07/23.
//

import Foundation
import SwiftUI

struct CommentModel: Identifiable, Hashable {
    
    var id = UUID()
    var commentID: String // ID for the comment in the DB
    var userID: String // ID for the user in the DB
    var username: String // username for the user in the DB
    var content: String // content of the comment
    var dateCreated: Date // so later can sort by date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
