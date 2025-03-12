//
//  Requets.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 12.03.2025.
//
/*
import Alamofire

func fetchRequests(completion: @escaping ([Request]?) -> Void) {
    let url = "https://localhost:7102/api/Requests/my"
    
    AF.request(url).responseDecodable(of: [Request].self) { response in
        switch response.result {
        case .success(let requests):
            completion(requests)
        case .failure(let error):
            print("Error: \(error)")
            completion(nil)
        }
    }
}
*/
