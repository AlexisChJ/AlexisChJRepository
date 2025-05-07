//
//  UserSession.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 13/10/24.
//
 import Foundation

class UserSession {
    static let shared = UserSession()
    var user: User?

    private init() {}
}
