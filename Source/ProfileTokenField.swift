//
//  ProfileTokenField.swift
//  ProfileTokenFieldDemo
//
//  Created by Gokul Ganapathy on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit

protocol ProfileTokenFieldDelegate {
    func didAdd(token: ProfileToken, atIndex index : Int)
    func didRemove(token: ProfileToken, atIndex index : Int)
    func shouldAdd(token: ProfileToken, withText text : String) -> Bool
    func contentHeightOfProfileTokenField(height : CGFloat)
}

class ProfileTokenField : UIView {
    
    public var tokens = [ProfileToken]()
    public var tokenHeight : CGFloat = 40
    public var isScrollEnabled : Bool = true {
        didSet {
            scrollView.isScrollEnabled  = isScrollEnabled
        }
    }
    var delegate : ProfileTokenFieldDelegate?
    
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
    
    func tokenTest() {
        for i in 0...4 {
            addToken(forText: "text \(i)")
        }
    }
    
    //MARK:- Public Methods
    func addToken(forText text: String) {
        let profileToken = Bundle.main.loadNibNamed("ProfileToken", owner: nil, options: nil)![0] as? ProfileToken
        profileToken?.backgroundColor = UIColor.red
        profileToken?.label.text = text
        profileToken?.removeButton
            .addTarget(self, action: #selector(ProfileTokenField.removeTokenButtonTapped(_:)), for: .touchUpInside )
        tokens.append(profileToken!)
        self.scrollView.addSubview(profileToken!)
        self.setNeedsLayout()
        delegate?.didAdd(token: profileToken!, atIndex: tokens.count - 1)
    }
    
    @objc func removeTokenButtonTapped(_ sender : UIButton)  {
        guard let token = sender.superview as? ProfileToken else {
            return
        }
        removeToken(token)
    }
    
    func removeToken(_ token : ProfileToken) {
        if let index = tokens.index(of: token) {
            tokens.remove(at: index)
            token.removeFromSuperview()
            self.setNeedsLayout()
            delegate?.didRemove(token: token, atIndex: index)
        }
    }
    
    //MARK:- Layout Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        calulateFrameForTokens()
        self.invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentRect.size
    }
    
    //MARK:- Height Calculations
    fileprivate func calulateFrameForTokens() {
        var xPosition : CGFloat = 0, yPosition : CGFloat = 0
        self.contentRect = .zero
        let contentWidth = self.bounds.width
        
        for token in tokens {
            let tokenWidth = token.getWidth(withSize: CGSize(width: self.bounds.width, height: tokenHeight))
            if(xPosition > contentWidth - tokenWidth) {
                yPosition += tokenHeight + 10
                xPosition = 0
            }
            token.frame = CGRect.init(x: xPosition, y: yPosition, width: tokenWidth, height: tokenHeight)
            contentRect = contentRect.union(token.frame)
            xPosition += tokenWidth + 10
        }
        
        self.scrollView.contentSize = contentRect.size
        delegate?.contentHeightOfProfileTokenField(height: contentRect.height)
    }
    
}
