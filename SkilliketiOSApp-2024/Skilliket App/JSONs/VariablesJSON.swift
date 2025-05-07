//
//  VariablesJSON.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 15/10/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class WelcomeVAR: Codable {
    let devices: [Device]

    init(devices: [Device]) {
        self.devices = devices
    }
}

// MARK: - Device
class Device: Codable {
    let name: String
    let environmentalVariables: [EnvironmentalVariable]
    let projectID: Int

    enum CodingKeys: String, CodingKey {
        case name
        case environmentalVariables = "environmental_variables"
        case projectID = "project_id"
    }

    init(name: String, environmentalVariables: [EnvironmentalVariable], projectID: Int) {
        self.name = name
        self.environmentalVariables = environmentalVariables
        self.projectID = projectID
    }
}

// MARK: - EnvironmentalVariable
class EnvironmentalVariable: Codable {
    let name: Name
    let units: Units
    let value: Double
    let date: String

    init(name: Name, units: Units, value: Double, date: String) {
        self.name = name
        self.units = units
        self.value = value
        self.date = date
    }
}

enum DateEnum: String, Codable {
    case tue15Oct2024003328 = "Tue, 15 Oct 2024 00:33:28"
    case tue15Oct2024003329 = "Tue, 15 Oct 2024 00:33:29"
}

enum Name: String, Codable {
    case atmosphericPressure = "atmospheric_pressure"
    case humidity = "humidity"
    case temperature = "temperature"
    case windSpeed = "wind_speed"
}

enum Units: String, Codable {
    case c = "C"
    case empty = "%"
    case kPa = "kPa"
    case mS = "m/s"
}

