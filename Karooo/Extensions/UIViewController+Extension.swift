//
//  UIViewController+Extension.swift
//  Karooo
//
//  Created by Jitender on 23/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alert(message: String, title: String = "Error" ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension String{
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        let passRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{8,64}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return passPred.evaluate(with: self)
    }
        
}

extension String
{
    public func toDouble() -> Double?
    {
       if let num = NumberFormatter().number(from: self) {
           return round(1000 * num.doubleValue) / 1000
            } else {
                return nil
            }
     }
}
