//
//  GroupFeedCell.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-09-29.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(profileImageReference: StorageReference, email: String, content: String) {
        self.profileImage.sd_setImage(with: profileImageReference, placeholderImage: UIImage(named: "defaultProfileImage")!)
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
}
