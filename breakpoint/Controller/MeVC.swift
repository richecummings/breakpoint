//
//  MeVC.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-09-23.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit

class MeVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
    }
}
