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
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTokenField.tokenTest()
    }
    

}

