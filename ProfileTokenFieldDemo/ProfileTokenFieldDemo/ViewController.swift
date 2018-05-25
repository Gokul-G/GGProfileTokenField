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
    @IBOutlet weak var profileTokenFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTokenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTokenField.delegate = self
        profileTokenField.tokenTest()
    }
    
    @IBAction func addTokenButtonTapped(_ sender: Any) {
        profileTokenField.addToken(forText: "newToken")
    }
        
}

extension ViewController : ProfileTokenFieldDelegate {
    
    func didAdd(token: ProfileToken, atIndex index: Int) {
        
    }
    
    func didRemove(token: ProfileToken, atIndex index: Int) {
        
    }
    
    func shouldAddToken(withText text: String) -> Bool {
        //validate text and return 
        return true
    }
    
    func contentHeightOfProfileTokenField(height: CGFloat) {
        profileTokenFieldHeightConstraint.constant = height
    }
    
}

