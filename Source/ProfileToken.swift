//
//  ProfileToken.swift
//  ProfileTokenFieldDemo
//
//  Created by Gokul G on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import Foundation
import UIKit

class ProfileToken: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var label: UILabel!    
    @IBOutlet weak var closeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
    }
    
    func getWidth(withSize size : CGSize) -> CGFloat {
        return self.label.sizeThatFits(size).width + 30 + 30 + 30
    }
    
}
