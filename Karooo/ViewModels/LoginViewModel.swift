//
//  LoginViewModel.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import Foundation

enum ValidationState {
    case Valid
    case Invalid(String)
}

class LoginViewModel {
    
    var db:DBHelper = DBHelper()
    
    var email:String = ""
    var password:String = ""
    var country:String = ""
  
    func validate() -> ValidationState {
        if email.isEmpty && password.isEmpty && country.isEmpty {
            return .Invalid("Invalid email and password and country")
        }
        if !email.isValidEmail() {
            return .Invalid("please provide valid email")
        }
        if !password.isValidPassword() {
            return .Invalid("A minimum 8 characters password contains a combination of uppercase and lowercase letter and special symbol and number are required.")
        }
        return .Valid
    }
    
    func loginRequest(_ completion:@escaping (_ status:Bool?, _ msg:String?) -> Void){
        let users = db.read()
            
        if users.count > 0 {
            for user in users
            {
                if user.email == email
                {
                    if user.password == password {
                        completion(true, nil)
                    }else{
                        completion(false, "Please provide valid password")
                    }
                }else{
                    db.insert(email: email, password: password, country: country) { status in
                        if status ?? false {
                            completion(true, nil)
                        }else{
                            completion(true, "Please try again after some time")
                        }
                    }
                }
            }
        }else{
            db.insert(email: email, password: password, country: country) { status in
                if status ?? false {
                    completion(true, nil)
                }else{
                    completion(true, "Please try again after some time")
                }
            }
        }
    }
}
