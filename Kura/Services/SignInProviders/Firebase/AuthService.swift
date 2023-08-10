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

class AuthService {
    
    // MARK: PROPERTIES
    
    static let instance = AuthService()
    
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
    
}
