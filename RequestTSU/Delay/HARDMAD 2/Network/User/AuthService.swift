//
//  AuthService.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 12.03.2025.
//


import Alamofire

class AuthService {
    static let shared = AuthService()
    private let baseURL = "http://localhost:5163/api" // Замените на ваш URL
    
    // Регистрация
    func register(user: UserDto, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = "\(baseURL)/Auth/register"
        
        AF.request(url, method: .post, parameters: user, encoder: JSONParameterEncoder.default).responseDecodable(of: AuthResponse.self) { response in
            switch response.result {
            case .success(let authResponse):
                completion(.success(authResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Логин
    func login(credentials: LoginDto, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = "\(baseURL)/Auth/login"
        
        AF.request(url, method: .post, parameters: credentials, encoder: JSONParameterEncoder.default).responseDecodable(of: AuthResponse.self) { response in
            switch response.result {
            case .success(let authResponse):
                completion(.success(authResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
