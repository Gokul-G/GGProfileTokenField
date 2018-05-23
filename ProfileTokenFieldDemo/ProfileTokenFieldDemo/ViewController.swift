//
//  ViewController.swift
//  ProfileTokenFieldDemo
//
//  Created by Gokul Ganapathy on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var profileTokenField: ProfileTokenField!
    @IBOutlet weak var addTokenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTokenField.tokenTest()
    }
    
    @IBAction func addTokenButtonTapped(_ sender: Any) {
        profileTokenField.addToken(forText: "newToken")
    }
    
    

}

