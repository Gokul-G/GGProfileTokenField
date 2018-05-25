//
//  ProfileTokenFieldDelegate.swift
//  ProfileTokenFieldDemo
//
//  Created by Gokul G on 25/05/18.
//  Copyright © 2018 gokul. All rights reserved.
//

import UIKit

protocol ProfileTokenFieldDelegate {
    
    /// didAdd method gets called when ever a new token is added to ProfileTokenField
    /// - Parameters:
    ///   - token: new token added
    ///   - index: index at which the token is added
    func didAdd(token: ProfileToken, atIndex index : Int)
    
    
    /// didRemove method gets called when ever a token is removed from ProfileTokenField
    ///
    /// - Parameters:
    ///   - token: token that is removed
    ///   - index: index at which the token was removed from
    func didRemove(token: ProfileToken, atIndex index : Int)
    
    
    /// shouldAddToken - validates the text thats being added, only if true gets added to ProfileTokenField
    /// - Parameter text: text being added in ProfileTokenField
    /// - Returns: Bool - to indicate whether the text can be added or not
    func shouldAddToken(withText text : String) -> Bool
    
    
    /// contentHeightOfProfileTokenField
    /// - Parameter height: content height of the ProfileTokenField after every addition or removal
    func contentHeightOfProfileTokenField(height : CGFloat)
}



extension ProfileTokenFieldDelegate {
    func shouldAddToken(withText text : String) -> Bool {
        return true
    }
}
