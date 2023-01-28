//
//  User.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import Foundation

class User {
    
    var email: String = ""
    var password: String = ""
    var country: String = ""
    
    init(email:String, password:String, country:String)
    {
        self.email = email
        self.password = password
        self.country = country
    }
}
