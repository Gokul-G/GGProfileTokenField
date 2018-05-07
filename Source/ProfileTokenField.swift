//
//  ProfileTokenField.swift
//  ProfileTokenFieldDemo
//
//  Created by Gokul Ganapathy on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit

protocol ProfileTokenFieldDelegate {
    func didAdd(token: ProfileTokenField, atIndexPath indexPath : IndexPath)
    func didRemove(token: ProfileTokenField, atIndexPath indexPath : IndexPath)
    func shouldAdd(token: ProfileTokenField, withText text : String) -> Bool
}

class ProfileTokenField : UIView {
    override func awakeFromNib() {
        self.backgroundColor = UIColor.green
    }
    
    func tokenTest() {
        for i in 0...5 {            
            let profileToken = Bundle.main.loadNibNamed("ProfileToken", owner: nil, options: nil)![0] as? ProfileToken
            profileToken?.backgroundColor = UIColor.red
            profileToken?.label.text = "test"
            profileToken?.frame = CGRect(x:CGFloat(i) * 85, y: 0, width: 60, height: 50)
            self.addSubview(profileToken!)
        }
        self.invalidateIntrinsicContentSize()
    }
    
    
}
