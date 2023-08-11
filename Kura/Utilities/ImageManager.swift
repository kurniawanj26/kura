//
//  ImageManager.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/08/23.
//

import Foundation
import FirebaseStorage

class ImageManager {
    
    // MARK: PROPERTIES
    
    static let instance = ImageManager()
    
    private var REF_STORE = Storage.storage()
    
    // MARK: PUBLIC FUNCTIONS
    // functions that can be called from other places in the app
    
    func uploadProfileImage(userID: String, image: UIImage) {
        
        // get the path where we will save the image
        let path = getProfileImagePath(userID: userID)
        
        // save image
        uploadImage(path: path, image: image) { (_) in }
        
    }
    
    func uploadPostImage(postID: String, image: UIImage, handler: @escaping (_ success: Bool) -> ()) {
        
        // get the path where we will save the image
        let path = getPostImagePath(postID: postID)
        
        // save image
        uploadImage(path: path, image: image) { success in
            handler(success)
        }
    }
    
    // MARK: PRIVATE FUNCTIONS
    // functions that can be called from this file only
    
    private func getProfileImagePath(userID: String) -> StorageReference {
        
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STORE.reference(withPath: userPath)
        return storagePath
        
    }
    
    private func getPostImagePath(postID: String) -> StorageReference {
        
        let postPath = "posts/\(postID)/1"
        let storagePath = REF_STORE.reference(withPath: postPath)
        return storagePath
    }
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping(_ success: Bool) ->()) {
        
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 240 * 240 // max file size
        let maxCompression: CGFloat = 0.05 // max file compression
        
        // get image data
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // check maximum filesize
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
            print(compression)
        }
        
        // get image data
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            handler(false)
            return
        }
        
        // get metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // save data to path
        path.putData(finalData, metadata: metadata) { (_, error) in
            
            if let error = error {
                // error
                print("Error uploading image. \(error)")
                handler(false)
                return
            } else {
                // success
                print("Success uploading image")
                handler(true)
                return
            }
        }
        
    }
}
