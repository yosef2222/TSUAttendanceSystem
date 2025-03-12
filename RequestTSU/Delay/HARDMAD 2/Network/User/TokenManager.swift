//
//  TokenManager.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 12.03.2025.
//

import Foundation
import JWTDecode

class TokenManager {
    static let shared = TokenManager()
    private let tokenKey = "jwtToken"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
    
    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
    
    func getStudentId() -> String? {
        guard let token = getToken() else {
            return nil
        }
        
        do {
            let jwt = try decode(jwt: token)
            if let studentId = jwt.body["studentId"] as? String {
                return studentId
            }
        } catch {
            print("Ошибка при декодировании токена: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func validateToken(completion: @escaping (Bool) -> Void) {
        guard let token = getToken() else {
            completion(false)
            return
        }
        
        if let url = URL(string: "http://localhost:5163/api/Auth/profile") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Ошибка сети: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("okay")
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
            
            task.resume()
        } else {
            completion(false)
        }
    }
}
