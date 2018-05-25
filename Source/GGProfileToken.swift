//
//  GGProfileToken.swift
//  GGProfileTokenFieldDemo
//
//  Created by Gokul G on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import Foundation
import UIKit

class GGProfileToken: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!    
    @IBOutlet weak var removeButton: UIButton!
    
    //MARK:- Constraints
    @IBOutlet weak var profileImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var removeButtonWidthConstraint: NSLayoutConstraint!
        
    @IBOutlet weak var profileImageViewAndLabelSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelAndRemoveButtonSpaceConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        self.layer.cornerRadius = 15
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
        self.profileImageView.clipsToBounds = true
    }
    
    func setProfileImage(withURL imageURL : URL, placeHolderImage: UIImage?)  {
        self.profileImageView.image = placeHolderImage
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async() {
                    self.profileImageView.image = image
                }
            }
        }).resume()
    }
    
    func hideRemoveButton() {
        removeButtonWidthConstraint.constant = 0
        labelAndRemoveButtonSpaceConstraint.constant = 0
        removeButton.isHidden = true
    }
    
    func hideProfileImageView() {
        profileImageViewWidthConstraint.constant = 0
        profileImageViewAndLabelSpaceConstraint.constant = 0
        profileImageView.isHidden = true
    }
    
}
