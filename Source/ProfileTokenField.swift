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
    
    var scrollView = UIScrollView()
    var tokens = [ProfileToken]()
    fileprivate var contentRect = CGRect.zero
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.green
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    
    func setUpViews() {
        scrollView.frame = self.bounds
        scrollView.isScrollEnabled = true
        scrollView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        self.addSubview(scrollView)
    }
    
    
    func tokenTest() {
        for i in 0...15 {
            let profileToken = Bundle.main.loadNibNamed("ProfileToken", owner: nil, options: nil)![0] as? ProfileToken
            profileToken?.backgroundColor = UIColor.red
            profileToken?.label.text = "test"
            profileToken?.frame = CGRect(x:CGFloat(i) * 85, y: 0, width: 60, height: 50)
            tokens.append(profileToken!)
            self.scrollView.addSubview(profileToken!)
        }
        self.invalidateIntrinsicContentSize()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calulateFrameForTokens()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentRect.size
    }
    
    func calulateFrameForTokens() {
        
        var xPosition : CGFloat = 0, yPosition : CGFloat = 0
        self.contentRect = .zero
        let contentWidth = self.bounds.width
        
        for token in tokens {
            let tokenWidth = min(self.bounds.width, token.bounds.width)
            if(xPosition > contentWidth - tokenWidth) {
                yPosition += token.bounds.height + 10
                xPosition = 0
            }
            token.frame = CGRect.init(x: xPosition, y: yPosition, width: tokenWidth, height: token.frame.height)
            contentRect = contentRect.union(token.frame)
            xPosition += tokenWidth + 10
        }
        
        self.scrollView.contentSize = CGSize(width: self.contentRect.width, height: self.contentRect.height)
    }
    
}
