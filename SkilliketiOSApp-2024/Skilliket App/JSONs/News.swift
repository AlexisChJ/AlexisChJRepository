//
//  News.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 06/10/24.
//

import Foundation

class News{
    let name: String
    let description: String
    let date: String
    let imageLink: String
    
    init(name: String, description: String, date: String, imageLink: String) {
        self.name = name
        self.description = description
        self.date = date
        self.imageLink = imageLink
    }
}
