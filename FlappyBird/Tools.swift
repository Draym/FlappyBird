//
//  Tools.swift
//  FlappyBird
//
//  Created by Admin on 03/12/2016.
//  Copyright © 2016 Fullstack.io. All rights reserved.
//

import UIKit

class Tools {
    static func getImageView(view: UIView, id: String) -> UIImageView? {
        for subview in view.subviews
        {
            if subview is UIImageView
            {
                if subview.accessibilityIdentifier == id {
                    return subview as? UIImageView
                }
            }
        }
        return nil
    }
    
    static func getTextView(view: UIView, id: String) -> UITextView? {
        for subview in view.subviews
        {
            if subview is UITextView
            {
                if subview.accessibilityIdentifier == id {
                    return subview as? UITextView
                }
            }
        }
        return nil
    }
    
    static func getLabel(view: UIView, id: String) -> UILabel? {
        for subview in view.subviews
        {
            if subview is UILabel
            {
                if subview.accessibilityIdentifier == id {
                    return subview as? UILabel
                }
            }
        }
        return nil
    }
}
