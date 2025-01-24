//
//  GFButton.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 22/01/25.
//

import UIKit
import SwiftUI


class GFButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(type: UIButton.ButtonType = .system, backgroundColor: UIColor, title: String, configuration: Bool = true) {
        self.init(type: type)
        if configuration {
            self.configure(title: title, backgroundColor: backgroundColor)
        } else {
            self.setBackgroundColor(color: backgroundColor, forState: .normal)
            self.setTitle(title, for: .normal)
            self.configure()
        }
    }
    
    // Shared configuration logic
    private func configure(title: String, backgroundColor: UIColor) {
        var configuration = UIButton.Configuration.filled()
//        configuration.title = title
        configuration.attributedTitle = AttributedString(title)
        configuration.attributedTitle?.font = .preferredFont(forTextStyle: .title1)
        configuration.baseBackgroundColor = backgroundColor
        configuration.baseForegroundColor = .white
        configuration.titleAlignment = .center
        configuration.cornerStyle = .medium
        
        self.configuration = configuration
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configure() {
        titleLabel?.font = .preferredFont(forTextStyle: .title1)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setBackgroundColor(color: UIColor, forState state: UIControl.State) {
        let image = UIImage(color: color)
        self.setBackgroundImage(image, for: state)
    }
}

