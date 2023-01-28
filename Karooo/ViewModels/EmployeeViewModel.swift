//
//  EmployeeViewModel.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import Foundation

class EmployeeViewModel {
    
    private let usersUrlPath = "https://jsonplaceholder.typicode.com/users"
    
    func fetchProfile(success:@escaping ([Employee])->Void, failure: @escaping (String) -> Void){
        APIService.shared.requestGETURL(urlString: usersUrlPath) { (response:[Employee]) in
            success(response)
        } failure: { (message) in
            failure(message ?? "Please try again after some time.")
        }
    }
}
