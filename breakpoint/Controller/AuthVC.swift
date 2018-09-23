//
//  AuthVC.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-08-28.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInWithEmailBtnWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInBtnWasPressed(_ sender: Any) {
    }
    
    @IBAction func facebookSignInBtnWasPressed(_ sender: Any) {
    }
}
