//
//  User.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 06/10/24.
//

import Foundation

class User{
    var email:String
    var password:String
    var firstname: String
    var lastname: String
    var age: Int
    var gender: String
    var typeUser:Int = 3
    var experience:String?
    var educationLevel:String?
    var projects:String?
    var links:String?
    init(email: String, password:String, firstname: String, lastname: String, age: Int, gender: String, typeUser:Int, experience:String?, educationLevel:String?, projects:String?, links:String?) {
        self.email = email
        self.password = password
        self.firstname =  firstname
        self.lastname =  lastname
        self.age = age
        self.gender = gender
        self.typeUser = typeUser
        self.experience = experience
        self.educationLevel = educationLevel
        self.projects = projects
        self.links = links
    }
}
