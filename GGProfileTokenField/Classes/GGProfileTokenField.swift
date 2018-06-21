//
//  GGProfileTokenField.swift
//  GGProfileTokenFieldDemo
//
//  Created by Gokul Ganapathy on 07/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit
import Foundation

public class GGProfileTokenField : UIView {
   
    public var font :UIFont?
    public var tokens = [GGProfileToken]()
    public var tokenHeight : CGFloat = 40
    public var profileImageWidth : CGFloat = 30
    public var removeButtonWidth : CGFloat = 20
    public var itemSpacing : CGFloat = 10
    public var lineSpacing : CGFloat = 5
    public var padding : CGFloat = 5
    public var isProfileImageHidden : Bool = false
    public var isRemoveHidden : Bool = false
    private var textField = GGProfileTokenTextField()
   
    public var isScrollEnabled : Bool = true {
        didSet {
            scrollView.isScrollEnabled  = isScrollEnabled
        }
    }
    
    public var delegate : GGProfileTokenFieldDelegate?
    
    fileprivate var scrollView = UIScrollView()
    fileprivate var contentRect = CGRect.zero
    
    override open func awakeFromNib() {
        self.backgroundColor = UIColor.green
    }
    
    //MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    fileprivate func setUpViews() {
        scrollView.frame = self.bounds
        scrollView.isScrollEnabled = true
        scrollView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        scrollView.addSubview(textField)
        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: UIControlEvents.editingChanged)
        textField.delegate = self
        textField.backgroundColor = UIColor.gray
        self.addSubview(scrollView)
    }
}


//MARK:- Public Methods
public extension GGProfileTokenField {
    
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
    
}


extension GGProfileTokenField {
    fileprivate func createProfileToken() -> GGProfileToken {
        let bundle = Bundle(for: GGProfileToken.self)
        let resourceBundlePath = bundle.path(forResource: "GGProfileTokenField", ofType: "bundle")!
        let resourceBundle = Bundle(path: resourceBundlePath)!
        let profileToken = resourceBundle.loadNibNamed("GGProfileToken", owner: nil, options: nil)![0] as? GGProfileToken
        profileToken?.removeButton.addTarget(self, action: #selector(GGProfileTokenField.removeTokenButtonTapped(_:)), for: .touchUpInside )
        profileToken?.textLabel.font = font
        profileToken?.profileImageViewWidthConstraint.constant = self.profileImageWidth
        profileToken?.removeButtonWidthConstraint.constant = self.removeButtonWidth
        profileToken?.leftPaddingConstraint.constant = self.padding
        profileToken?.rightPaddingConstraint.constant = self.padding
        
        if self.isRemoveHidden {
            profileToken?.hideRemoveButton()
        }
        
        if self.isProfileImageHidden {
            profileToken?.hideProfileImageView()
        }
        
        return profileToken!
    }
    
    @objc func removeTokenButtonTapped(_ sender : UIButton)  {
        guard let token = sender.superview as? GGProfileToken else { return }
        removeToken(token)
    }
}

//MARK:- Layout Methods
extension GGProfileTokenField  {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        calulateFrameForTokens()
        self.invalidateIntrinsicContentSize()
    }
    
    override open var intrinsicContentSize: CGSize {
        return self.contentRect.size
    }
    
    //MARK:- Height Calculations
    private func calulateFrameForTokens() {
        var xPosition : CGFloat = 0, yPosition : CGFloat = 0
        self.contentRect = .zero
        let contentWidth = self.bounds.width
        var lastTokenFrame = CGRect.zero
        
        //Token Frame Calculations
        for token in tokens {
            let tokenWidth = calculateWidth(forToken:token)
            if(xPosition > contentWidth - tokenWidth) {
                xPosition = 0
                yPosition += tokenHeight + lineSpacing
            }
            
            token.frame = CGRect.init(x: xPosition, y: yPosition, width: tokenWidth, height: tokenHeight)
            contentRect = contentRect.union(token.frame)
            lastTokenFrame = token.frame
            xPosition += tokenWidth + itemSpacing
        }
        
        //TextField Frame Calcumations
        textField.sizeToFit()
        if lastTokenFrame.origin.x + textField.frame.width > contentWidth {
            textField.frame.origin.x = 0
            textField.frame.origin.y = lastTokenFrame.origin.y + tokenHeight + lineSpacing
        }else {
            textField.frame.origin.x = lastTokenFrame.origin.x + lastTokenFrame.width + itemSpacing
            textField.frame.origin.y = lastTokenFrame.origin.y
        }
        
        
        textField.frame.size.width = contentWidth - textField.frame.origin.x
        textField.frame.size.height = tokenHeight
        contentRect = contentRect.union(textField.frame)
        
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
        
        tokenWidth += padding //left
        tokenWidth += padding //right
        
        return tokenWidth
    }
}

extension GGProfileTokenField : UITextFieldDelegate {
    
    @objc public func textFieldChanged(_ sender :Any) {
        let textField = sender as! UITextField
        if let text = textField.text, text.last == " " {
            addToken(forText: String(text.dropLast()))
            textField.text = ""
        }
        layoutIfNeeded()
    }
}
