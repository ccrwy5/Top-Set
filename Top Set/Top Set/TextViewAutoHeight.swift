//
//  TextViewAutoHeight.swift
//  Top Set
//
//  Created by Chris Rehagen on 4/30/20.
//  Copyright © 2020 Chris Rehagen. All rights reserved.
//

import UIKit

@IBDesignable
class AKTextView: UITextView {

    fileprivate var placeholderLabel = UILabel()
    @IBInspectable var placeHolderColor: UIColor? = .gray {
        didSet {
            placeholderLabel.textColor = placeHolderColor
        }
    }
     @IBInspectable var placeHolder: String? {
        didSet {
            placeholderLabel.text = placeHolder
        }
    }
     var placeholderFont: UIFont!
    override func awakeFromNib() {
       initializePlaceholder()
    }
    
    // MARK: For initializing textView
    private func initializePlaceholder() {
        
        let lineFragmentPadding = self.textContainer.lineFragmentPadding
        let textContainerInset = self.textContainerInset
        let x = lineFragmentPadding + textContainerInset.left
        let y = textContainerInset.top
        let width = self.bounds.width - x - lineFragmentPadding - textContainerInset.right
        let height = placeholderLabel.sizeThatFits(CGSize(width: width, height: 0)).height
        
        placeholderLabel = UILabel(frame: CGRect(x: x, y: y, width: width , height: height))
        placeholderLabel.textColor = placeHolderColor
        placeholderLabel.numberOfLines = 0
        placeholderLabel.isUserInteractionEnabled = false
        self.delegate = self
        self.addSubview(placeholderLabel)
        placeholderLabel.text = placeHolder
        if self.text == "" {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
        self.placeholderLabel.font = self.font
        self.layoutIfNeeded()
    }
    
}

extension AKTextView : UITextViewDelegate {
    
    // MARK: For checking the charcaters on the textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        if numberOfChars == 0 {
             placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
        return true
    }
    
}
