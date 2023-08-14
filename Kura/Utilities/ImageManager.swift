//
//  ImageManager.swift
//  Kura
//
//  Created by Jayadi Kurniawan on 11/08/23.
//

import Foundation
import FirebaseStorage

// initialize a blank image cache
let imageCache = NSCache<AnyObject, UIImage>()

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
    
    func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        // get the path
        let path = getProfileImagePath(userID: userID)
        
        // download the image from path
        downloadImage(path: path) { returnedImage in
            handler(returnedImage)
        }
    }
    
    func downloadPostImage(postID: String, handler: @escaping (_ image: UIImage?) -> ()) {
        
        // get the path
        let path = getPostImagePath(postID: postID)
        
        // download the image from path
        downloadImage(path: path) { returnedImage in
            handler(returnedImage)
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
    
    private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: path) {
            print("Image found in cache")
            handler(cachedImage)
            return
        } else {
            path.getData(maxSize: 27 * 1024 * 1024) { returnedImageData, error in
                if let data = returnedImageData, let image = UIImage(data: data) {
                    // success getting image data
                    imageCache.setObject(image, forKey: path)
                    handler(image)
                    return
                } else {
                    // error
                    print("Error getting data from path for image")
                    handler(nil)
                    return
                }
            }
        }
        
    }
}
