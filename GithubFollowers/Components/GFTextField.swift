//
//  GFTextField.swift
//  GithubFollowers
//
//  Created by Muhammadjon Madaminov on 22/01/25.
//

import UIKit
import SwiftUI

class GFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        placeholder = "Enter username"
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        font = .preferredFont(forTextStyle: .title2)
        textAlignment = .center
        textColor = .label
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .go
        translatesAutoresizingMaskIntoConstraints = false
    }
}




#Preview {
    UIViewPreview(view: GFTextField())
        .frame(maxWidth: .infinity)
        .frame(height: 55)
        .padding()
}
