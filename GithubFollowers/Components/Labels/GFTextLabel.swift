//
//  GFTitleLabel.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 23/01/25.
//

import UIKit

class GFTextLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Body textlabel
    convenience init(title: String? = nil, font: UIFont, textAlignment: NSTextAlignment = .center, symbolName: String? = nil) {
        self.init(frame: .zero)
        self.text = title
        self.font = font
        self.textAlignment = textAlignment
        if let symbolName = symbolName {
            setSymbolImage(symbolName)
        }
        configure()
    }
    
    //Title textLabel
    convenience init(title: String? = nil, fontSize: CGFloat, textAlignment: NSTextAlignment = .center, symbolName: String? = nil) {
        self.init(frame: .zero)
        self.text = title
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.textAlignment = textAlignment
        if let symbolName = symbolName {
            setSymbolImage(symbolName)
        }
        titleConfigure()
    }
    
    
    private func titleConfigure() {
        self.textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configure() {
        self.textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.7
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setSymbolImage(_ name: String, spacing: CGFloat = 4) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: name)?
            .withTintColor(textColor, renderingMode: .alwaysOriginal)
        
        
        let imageString = NSAttributedString(attachment: imageAttachment)
        let textString = NSAttributedString(string: self.text ?? "")
        
        let spacer = NSAttributedString(string: " ", attributes: [.kern: spacing])
        
        let fullString = NSMutableAttributedString()
        fullString.append(imageString)
        fullString.append(spacer)
        fullString.append(textString)
        
        self.attributedText = fullString
    }
}
