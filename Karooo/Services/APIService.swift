//
//  APIService.swift
//  Karooo
//
//  Created by Jitender on 22/01/23.
//

import Foundation
import Alamofire

class APIService : NSObject {
    
    static let shared = APIService()
    
    func requestGETURL<T: Codable>(urlString:String, success: @escaping ((T) -> Void), failure: @escaping ((String?) -> Void)){
        AF.request(urlString).responseDecodable{ (response: DataResponse<T, AFError>) in
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
}

