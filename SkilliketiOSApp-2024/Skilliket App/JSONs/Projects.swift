//
//  Projects.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 11/10/24.
//

import Foundation

class Projects{
    let id: Int
    let title, location, country: String
    let numberOfParticipants: Int
    let imageLink: String
    let isActive: Bool
    let description: String
    let longitude, latitude: Double
    let userParticipation: String

    init(id: Int, title: String, location: String, country: String, numberOfParticipants: Int, imageLink: String, isActive: Bool, description: String, longitude: Double, latitude: Double, userParticipation: String) {
        self.id = id
        self.title = title
        self.location = location
        self.country = country
        self.numberOfParticipants = numberOfParticipants
        self.imageLink = imageLink
        self.isActive = isActive
        self.description = description
        self.longitude = longitude
        self.latitude = latitude
        self.userParticipation = userParticipation
    }
}
