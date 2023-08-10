//
//  AuthService.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 10/08/23.
//

// used to authenticate users in Firebase
// used to handle accounts in Firebase

import Foundation
import FirebaseAuth
import FirebaseFirestore

let DB_BASE = Firestore.firestore() // global variabel

class AuthService {
    
    // MARK: PROPERTIES
    
    static let instance = AuthService()
    
    private var REF_USERS = DB_BASE.collection("users")
    
    // MARK: AUTH USER FUNCTIONS
    
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool) ->()) {
        
        Auth.auth().signIn(with: credential) { result, error in
            
            // check for errors
            if error != nil {
                print("Error loggin in to Firebase")
                handler(nil, true)
                return
            }
            
            // check for provider ID
            guard let providerID = result?.user.uid else {
                print("Error getting provider ID")
                handler(nil, true)
                return
            }
            
            // success connecting to Firebase
            handler(providerID, false)
        }
        
    }
    
    func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) ->()) {
        
        // set up user document with the user collection
        let document = REF_USERS.document()
        let userID = document.documentID
        
        // upload profile image to Storage
        
        // upload profile data to Firestore
        let userData: [String: Any] = [
            DatabaseUserField.displayName : name,
            DatabaseUserField.email : email,
            DatabaseUserField.providerID : providerID,
            DatabaseUserField.provider : provider,
            DatabaseUserField.userID : userID,
            DatabaseUserField.bio : "",
            DatabaseUserField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        document.setData(userData) { (error) in
            if let error = error {
                // ERROR
                print("Error uploading data to user document. \(error)")
                handler(nil)
            } else {
                // SUCCESS
                handler(userID)
            }
        }
        
    }
    
}
