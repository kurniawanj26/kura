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
    
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) ->()) {
        
        Auth.auth().signIn(with: credential) { result, error in
            
            // check for errors
            if error != nil {
                print("Error loggin in to Firebase")
                handler(nil, true, nil, nil)
                return
            }
            
            // check for provider ID
            guard let providerID = result?.user.uid else {
                print("Error getting provider ID")
                handler(nil, true, nil, nil)
                return
            }
            
            // check if user already exist in database, if true skip the onboarding
            self.checkIfUserExistInDatabase(providerID: providerID) { returnedUserID in
            
                if let userID = returnedUserID {
                    // user exist, login to app
                    handler(providerID, false, false, userID)

                } else {
                    
                    // user doesn't exist, continue to onboarding a new user
                    handler(providerID, false, true, nil)
                }
            }
            
        }
        
    }
    
    func logInUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        
        // get the user info
        getUserInfo(forUserID: userID) { (returnedName, returnedBio) in
                        
            if let name = returnedName, let bio = returnedBio {
                // success login
                print("Success getting user info while logging in")
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // set the users info into the app
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)
                }
                
            } else {
                // error login
                print("Error getting user info while logging in")
                handler(false)
            }
                
        }
    
    }
    
    func logOutUser(handler: @escaping (_ success: Bool) -> ()) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error logging out \(error)")
            handler(false)
            return
        }
        
        handler(true)
        
        // update user defaults
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            // get all properties in user default
            // to make sure the app removed everything in user defaults
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            
            defaultsDictionary.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }

    }
    
    func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) ->()) {
        
        // set up user document with the user collection
        let document = REF_USERS.document()
        let userID = document.documentID
        
        // upload profile image to Storage
        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)
        
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
    
    private func checkIfUserExistInDatabase(providerID: String, handler: @escaping (_ existingUserID: String?) -> ()) {
        
        // if userID is returned, it means the user exist in the database
        
        REF_USERS.whereField(DatabaseUserField.providerID, isEqualTo: providerID).getDocuments { querySnapshot, error in
            
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                // success, existing user
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                // error, new user
                handler(nil)
                return
            }
        }
        
    }
    
    // MARK: GET USER FUNCTIONS
    // forUserID -> global
    // userID -> local
    func getUserInfo(forUserID userID: String, handler: @escaping(_ name: String?, _ bio: String?) -> ()) {
        
        REF_USERS.document(userID).getDocument { (documentSnapshot, error) in
            
            if let document = documentSnapshot,
               let name = document.get(DatabaseUserField.displayName) as? String,
               let bio = document.get(DatabaseUserField.bio) as? String {
                print("Success getting user info")
                handler(name, bio)
                return
            } else {
                print("Error getting user info")
                handler(nil, nil)
                return
            }
            
        }
        
    }
    
    // MARK: UPDATE USER FUNCTIONS
    func updateUserDisplayName(userID: String, displayName: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String: Any] = [
            DatabaseUserField.displayName: displayName
        ]
        
        REF_USERS.document(userID).updateData(data) { error in
            if let error = error {
                print("Error updating user display name: \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
    
    func updateUserBio(userID: String, bio: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String: Any] = [
            DatabaseUserField.bio: bio
        ]
        
        REF_USERS.document(userID).updateData(data) { error in
            if let error = error {
                print("Error updating user bio : \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
    
}
