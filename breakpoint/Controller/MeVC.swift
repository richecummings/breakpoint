//
//  MeVC.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-09-23.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    @IBOutlet weak var profileImageBtn: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
        let uid = Auth.auth().currentUser?.uid
        DataService.instance.getProfileImageName(forUID: uid!) { (imageName) in
            
            let placeholderImage = UIImage(named: "defaultProfileImage")
            StorageService.instance.downloadProfileImage(forUID: uid!, imageName: imageName, handler: { (imageReference) in
                self.profileImageView.sd_setImage(with: imageReference, placeholderImage: placeholderImage)
            })
        }
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    @IBAction func profileImageBtnWasPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension MeVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let chosenImageUrl = info[UIImagePickerControllerImageURL] as! URL
        let chosenImageName = chosenImageUrl.lastPathComponent
        let uid = Auth.auth().currentUser?.uid
        
        StorageService.instance.uploadProfileImage(forUID: uid!, imageUrl: chosenImageUrl)
        DataService.instance.setProfileImageName(forUID: uid!, imageName: chosenImageName) { (success) in
            if success {
                self.profileImageView.image = chosenImage
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
