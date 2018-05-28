//
//  ViewController.swift
//  GGProfileTokenFieldDemo
//
//  Created by Gokul Ganapathy on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var profileTokenField: GGProfileTokenField!
    @IBOutlet weak var profileTokenFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTokenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTokenField.delegate = self
        profileTokenField.font = UIFont.init(name: "Avenir-Book", size: 12.0)        
        //populateTokenField()
    }    
    
    func populateTokenField(){
        for i in 0...1 {
            profileTokenField.addToken(forText: "textsafasfadsfsadfas\(i)")
        }
    }
    
    @IBAction func addTokenButtonTapped(_ sender: Any) {
        let imageURL = URL.init(string: "https://randomuser.me/api/portraits/women/40.jpg")
        profileTokenField.addToken(forText: "Miss Genie", withImageURL: imageURL!, placeHolderImage: #imageLiteral(resourceName: "defaultProfileImage"))
    }        
}

extension ViewController : GGProfileTokenFieldDelegate {
    
    func didAdd(token: GGProfileToken, atIndex index: Int) {
        
    }
    
    func didRemove(token: GGProfileToken, atIndex index: Int) {
        
    }
    
    func shouldAddToken(withText text: String) -> Bool {
        //validate text and return 
        return true
    }
    
    func contentHeightOfProfileTokenField(height: CGFloat) {
        if height > 200 {
            self.profileTokenFieldHeightConstraint.constant = 200
            profileTokenField.isScrollEnabled = true
        } else {
            self.profileTokenFieldHeightConstraint.constant = height
            profileTokenField.isScrollEnabled = false            
        }        
    }
}

