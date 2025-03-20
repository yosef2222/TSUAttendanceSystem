//
//  UserModel.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 11.03.2025.
//

import UIKit

struct UserDto: Codable {
    let fullName: String
    let birthday: String
    let email: String
    let password: String
    let groupNumber: String?
    let isStudent: Bool
}

struct LoginDto: Codable {
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let token: String
}

struct RequestModel: Codable {
    let studentId: String
    let reason: String
    let absenceDateStart: Date
    let absenceDateEnd: Date
    let status: Bool
    let files: [Data]?
}

struct RequestModels: Codable {
    let RequestModels: [RequestModel]
}

struct Profile: Codable {
    let fullName: String
    let email: String
    let birthDate: String
    let groupNumber: String
}

struct Role: Codable {
    let isStudent: Bool
    let isAdmin: Bool
    let isDean: Bool
    let isTeacher: Bool
}

struct Absence: Codable {
    let id: String
    let reason: String
    let absenceDateStart: String
    let absenceDateEnd: String
    let status: String
    let studentFullName: String
    let reviewedByFullName: String?
    let fileIds: [String]
}


struct ApprovedRequest: Codable {
    let id: String
    let reason: String
    let absenceDateStart: String
    let absenceDateEnd: String
    let status: String
    let studentFullName: String
    let reviewedByFullName: String
    let fileIds: [String]
}
