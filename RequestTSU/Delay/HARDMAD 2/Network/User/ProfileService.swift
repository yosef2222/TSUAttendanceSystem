//
//  ProfileService.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 12.03.2025.
//


import Foundation

class ProfileService {
    static let shared = ProfileService()
    
    // Метод для загрузки профиля
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let token = TokenManager.shared.getToken() else {
            completion(.failure(NSError(domain: "Token is missing", code: 401, userInfo: nil)))
            return
        }
        
        if let url = URL(string: "http://localhost:5163/api/Auth/profile") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    do {
                        let profile = try JSONDecoder().decode(Profile.self, from: data)
                        completion(.success(profile))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
                }
            }
            
            task.resume()
        } else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
        }
    }
    
    // Метод для загрузки ролей
    func fetchRoles(completion: @escaping (Result<Role, Error>) -> Void) {
        guard let token = TokenManager.shared.getToken() else {
            completion(.failure(NSError(domain: "Token is missing", code: 401, userInfo: nil)))
            return
        }
        
        if let url = URL(string: "http://localhost:5163/User/roles") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    do {
                        let roles = try JSONDecoder().decode(Role.self, from: data)
                        completion(.success(roles))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "Invalid response", code: 500, userInfo: nil)))
                }
            }
            
            task.resume()
        } else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
        }
    }
}
