//
//  UserCell.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-09-28.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
//    func configureCell(profileImage image: UIImage, email: String, isSelected: Bool) {
//        self.profileImage.image = image
//        self.emailLbl.text = email
//        if isSelected {
//            self.checkImage.isHidden = false
//        } else {
//            self.checkImage.isHidden = true
//        }
//    }
    
    func configureCell(profileImageReference: StorageReference, email: String, isSelected: Bool) {
        self.profileImage.sd_setImage(with: profileImageReference, placeholderImage: UIImage(named: "defaultProfileImage")!)
        self.profileImage.setRounded()
        self.emailLbl.text = email
        self.checkImage.isHidden = isSelected
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImage.isHidden = false
                showing = true
            } else {
                checkImage.isHidden = true
                showing = false
            }
        }
    }

}
