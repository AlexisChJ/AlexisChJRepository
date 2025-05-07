//
//  ProjectsJSON.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 11/10/24.
//


import Foundation

// MARK: - Welcome
class WelcomeJSON2: Codable {
    let projects: [ProjectJSON]

    init(projects: [ProjectJSON]) {
        self.projects = projects
    }
}

// MARK: - Project
class ProjectJSON: Codable {
    let id: Int
    let title, location, country: String
    let numberOfParticipants: Int
    let imageLink: String
    let isActive: Bool
    let description: String
    let longitude, latitude: Double
    let userParticipation: String

    enum CodingKeys: String, CodingKey {
        case id, title, location, country
        case numberOfParticipants = "number_of_participants"
        case imageLink = "image_link"
        case isActive = "is_active"
        case description, longitude, latitude, userParticipation
    }

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

enum ProjectsJSONError: Error, LocalizedError {
    case notConnected
    case notNewsFound
}

// MARK: - Fetching Data
extension WelcomeJSON2 {
    static func fetchProjectsJSON() async throws -> Welcome2 {
        guard let url = URL(string: "http://martinmolina.com.mx/martinmolina.com.mx/reto_skiliket/Equipo9/projects.json") else {
            throw ProjectsJSONError.notConnected
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ProjectsJSONError.notConnected
        }
        let jsonDecoder = JSONDecoder()
        let welcomeJSON2 = try jsonDecoder.decode(WelcomeJSON2.self, from: data)
        
        let projects = welcomeJSON2.projects.map { projectsJSON in
            Projects(id: projectsJSON.id, title: projectsJSON.title, location: projectsJSON.location, country: projectsJSON.country, numberOfParticipants: projectsJSON.numberOfParticipants, imageLink: projectsJSON.imageLink, isActive: projectsJSON.isActive, description: projectsJSON.description, longitude: projectsJSON.longitude, latitude: projectsJSON.latitude, userParticipation: projectsJSON.userParticipation)
        }
        return Welcome2(projects: projects)
    }
}
