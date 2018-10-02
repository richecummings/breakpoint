//
//  StorageService.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-09-30.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorageUI

let STORAGE_BASE = Storage.storage().reference()

class StorageService {
    static let instance = StorageService()
    
    private var _REF_BASE = STORAGE_BASE
    private var _REF_IMAGES = STORAGE_BASE.child("images")
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("images/profile")
    
    var REF_BASE: StorageReference {
        return _REF_BASE
    }
    
    var REF_IMAGES: StorageReference {
        return _REF_IMAGES
    }
    
    var REF_PROFILE_IMAGES: StorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    func uploadProfileImage(forUID uid: String, imageUrl: URL) {
        let metadata = StorageMetadata()
        let imageName = imageUrl.lastPathComponent
        metadata.contentType = "image/jpeg"

        let uploadTask = REF_PROFILE_IMAGES.child(uid).child(imageName).putFile(from: imageUrl, metadata: metadata)
    }
    
    func downloadProfileImage(forUID uid: String, handler: @escaping (_ image: UIImage) -> ()){
        var image = UIImage(named: "defaultProfileImage")
        let reference = REF_PROFILE_IMAGES.child(uid).child("08C4B4EE-1F4F-467A-9DF4-FC3A253ED759.jpeg")
        reference.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error)
            } else {
                image = UIImage(data: data!)
            }
        }
        
        handler(image!)
    }
    
    func downloadProfileImage(forUID uid: String, imageName: String, handler: @escaping (_ imageReference: StorageReference) -> ()) {
        let reference = REF_PROFILE_IMAGES.child(uid).child(imageName)
        handler(reference)
    }
}
