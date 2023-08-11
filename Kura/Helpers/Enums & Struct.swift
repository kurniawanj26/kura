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

// Fields for UserDefaults
struct CurrentUserDefaults {
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}
