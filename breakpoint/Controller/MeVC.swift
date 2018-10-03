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
    @IBOutlet weak var contentView: UIView!
    
    var messageArray = [Message]()
    var screenSize = UIScreen.main.bounds
    var imagePicker = UIImagePickerController()
    var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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
        self.profileImageView.setRounded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let uid = (Auth.auth().currentUser?.uid)!
        DataService.instance.getFeedMessages(forUID: uid, handler: { (returnedMessageArray) in
            self.messageArray = returnedMessageArray.reversed()
            DataService.instance.getGroupMessages(forUID: uid, handler: { (returnedGroupMessageArray) in
                self.messageArray.append(contentsOf: returnedGroupMessageArray.reversed())
                self.tableView.reloadData()
            })
        })
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
    
    func addSpinner() {
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        spinner?.startAnimating()
        //profileImageView.addSubview(spinner!)
        contentView.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
}

extension MeVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let chosenImageUrl = info[UIImagePickerControllerImageURL] as! URL
        let chosenImageName = chosenImageUrl.lastPathComponent
        let uid = Auth.auth().currentUser?.uid
        
        StorageService.instance.getUploadTask(forImageURL: chosenImageUrl, uid: uid!) { (uploadTask) in
            self.addSpinner()
            uploadTask.observe(.success, handler: { (snapshot) in
                DataService.instance.setProfileImageName(forUID: uid!, imageName: chosenImageName) { (success) in
                    if success {
                        self.profileImageView.image = chosenImage
                        self.removeSpinner()
                    }
                }
            })
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "meCell") as? MeCell else { return UITableViewCell() }
        let message = messageArray[indexPath.row]
        let username = Auth.auth().currentUser?.email
        
        DataService.instance.getProfileImageName(forUID: message.senderId) { (returnedImageName) in
            StorageService.instance.downloadProfileImage(forUID: message.senderId, imageName: returnedImageName, handler: { (imageReference) in
                cell.configureCell(profileImageReference: imageReference, email: username!, content: message.content)
            })
        }
        
        return cell
    }
}
