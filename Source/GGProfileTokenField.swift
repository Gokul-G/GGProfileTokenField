//
//  GGProfileTokenField.swift
//  GGProfileTokenFieldDemo
//
//  Created by Gokul Ganapathy on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit
import Foundation

class GGProfileTokenField : UIView {
    
    public var tokens = [GGProfileToken]()
    public var tokenHeight : CGFloat = 40
    public var profileImageWidth : CGFloat = 30
    public var removeButtonWidth : CGFloat = 20
    public var itemSpacing : CGFloat = 10
    public var lineSpacing : CGFloat = 5
    public var padding : CGFloat = 5
    
    public var isProfileImageHidden : Bool = false
    public var isRemoveHidden : Bool = false
    
    public var isScrollEnabled : Bool = true {
        didSet {
            scrollView.isScrollEnabled  = isScrollEnabled
        }
    }
    
    var delegate : GGProfileTokenFieldDelegate?
    
    fileprivate var scrollView = UIScrollView()
    fileprivate var contentRect = CGRect.zero
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.green
    }
    
    //MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    fileprivate func setUpViews() {
        scrollView.frame = self.bounds
        scrollView.isScrollEnabled = true
        scrollView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        self.addSubview(scrollView)        
    }
}


extension GGProfileTokenField {
    //MARK:- Public Methods
    func addToken(forText text: String, withImage image : UIImage? = nil) {
        let validToken = delegate?.shouldAddToken(withText: text) ?? false
        guard validToken else { return }
        
        let profileToken = createProfileToken()
        profileToken.textLabel.text = text
        profileToken.profileImageView.image = image
        tokens.append(profileToken)
        self.scrollView.addSubview(profileToken)
        self.setNeedsLayout()
        delegate?.didAdd(token: profileToken, atIndex: tokens.count - 1)
    }
    
    func addToken(forText text: String, withImageURL imageURL : URL, placeHolderImage : UIImage?) {
        let validToken = delegate?.shouldAddToken(withText: text) ?? false
        guard validToken else { return }
        
        let profileToken = createProfileToken()
        profileToken.textLabel.text = text
        profileToken.setProfileImage(withURL: imageURL, placeHolderImage: placeHolderImage)
        tokens.append(profileToken)
        self.scrollView.addSubview(profileToken)
        self.setNeedsLayout()
        delegate?.didAdd(token: profileToken, atIndex: tokens.count - 1)
    }
    
    
    func removeToken(_ token : GGProfileToken) {
        guard let index = tokens.index(of: token) else { return }
            
        tokens.remove(at: index)
        token.removeFromSuperview()
        self.setNeedsLayout()
        delegate?.didRemove(token: token, atIndex: index)
    }
    
    @objc func removeTokenButtonTapped(_ sender : UIButton)  {
        guard let token = sender.superview as? GGProfileToken else { return }
        removeToken(token)
    }
}


extension GGProfileTokenField {
    
    func createProfileToken() -> GGProfileToken {
        let profileToken = Bundle.main.loadNibNamed("GGProfileToken", owner: nil, options: nil)![0] as? GGProfileToken
        profileToken?.removeButton.addTarget(self, action: #selector(GGProfileTokenField.removeTokenButtonTapped(_:)), for: .touchUpInside )
        
        profileToken?.profileImageViewWidthConstraint.constant = self.profileImageWidth
        profileToken?.removeButtonWidthConstraint.constant = self.removeButtonWidth
        
        if self.isRemoveHidden {
            profileToken?.hideRemoveButton()
        }
        
        if self.isProfileImageHidden {
            profileToken?.hideProfileImageView()
        }
        
        return profileToken!
    }
}

//MARK:- Layout Methods
extension GGProfileTokenField  {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calulateFrameForTokens()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentRect.size
    }
    
    //MARK:- Height Calculations
    private func calulateFrameForTokens() {
        var xPosition : CGFloat = 0, yPosition : CGFloat = 0
        self.contentRect = .zero
        let contentWidth = self.bounds.width
        
        for token in tokens {
            let tokenWidth = calculateWidth(forToken:token)
            if(xPosition > contentWidth - tokenWidth) {
                yPosition += tokenHeight + lineSpacing
                xPosition = 0
            }
            token.frame = CGRect.init(x: xPosition, y: yPosition, width: tokenWidth, height: tokenHeight)
            contentRect = contentRect.union(token.frame)
            xPosition += tokenWidth + 10
        }
        
        self.scrollView.contentSize = contentRect.size
        delegate?.contentHeightOfProfileTokenField(height: contentRect.height)
    }
    
    private func calculateWidth(forToken token: GGProfileToken) -> CGFloat {
        let labelWeidth = token.textLabel.sizeThatFits(CGSize(width: self.bounds.width, height: tokenHeight)).width
        var tokenWidth = labelWeidth
       
        if !isRemoveHidden {
            tokenWidth += removeButtonWidth
            tokenWidth += itemSpacing
        }
        
        if !isProfileImageHidden {
            tokenWidth += profileImageWidth
            tokenWidth += itemSpacing
        }
        
        tokenWidth += padding
        tokenWidth += padding
        
        return tokenWidth
    }
    
}
