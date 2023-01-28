//
//  PasswordTextField.swift
//  Karooo
//
//  Created by Jitender on 23/01/23.
//

import Foundation
import UIKit

class PasswordTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.isSecureTextEntry = true
        
        //show/hide button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(named: "eye"), for: .normal)
        button.setImage(UIImage(named: "eye-off"), for: .selected)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 12)
        button.sizeToFit()
        rightView = button
        rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}
