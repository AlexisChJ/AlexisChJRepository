//
//  NetHealth.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 12/10/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
class WelcomePT2: Codable {
    let response: [ResponsePT]
    let version: String

    init(response: [ResponsePT], version: String) {
        self.response = response
        self.version = version
    }
}


enum WelcomePT2Error: Error, LocalizedError{
    case HealthNotFound
    case TokenGenerationError
}
// MARK: - Response
class ResponsePT: Codable, Identifiable {
    let clients: Clients
    let networkDevices: NetworkDevices
    let timestamp: String

    init(clients: Clients, networkDevices: NetworkDevices, timestamp: String) {
        self.clients = clients
        self.networkDevices = networkDevices
        self.timestamp = timestamp
    }
}

// MARK: - Clients
class Clients: Codable, Identifiable {
    let totalConnected, totalPercentage: String

    init(totalConnected: String, totalPercentage: String) {
        self.totalConnected = totalConnected
        self.totalPercentage = totalPercentage
    }
}

// MARK: - NetworkDevices
class NetworkDevices: Codable, Identifiable {
    let networkDevices: [NetworkDevice]
    let totalDevices, totalPercentage: String

    init(networkDevices: [NetworkDevice], totalDevices: String, totalPercentage: String) {
        self.networkDevices = networkDevices
        self.totalDevices = totalDevices
        self.totalPercentage = totalPercentage
    }
}

// MARK: - NetworkDevice
class NetworkDevice: Codable, Identifiable {
    let deviceType: DeviceType
    let healthyPercentage: String
    let healthyRatio: HealthyRatio

    init(deviceType: DeviceType, healthyPercentage: String, healthyRatio: HealthyRatio) {
        self.deviceType = deviceType
        self.healthyPercentage = healthyPercentage
        self.healthyRatio = healthyRatio
    }
}

enum DeviceType: String, Codable {
    case routers = "Routers"
    case switches = "Switches"
}

enum HealthyRatio: String, Codable {
    case the34 = "3:4"
    case the44 = "4:4"
    case the45 = "4:5"
    case the55 = "5:5"
}

struct NetworkDevicePercentage: Identifiable {
    let id = UUID() // Se puede usar un identificador único
    let timeStamp: Date
    let totalPercentage: Double
}

extension WelcomePT2{
    static func getToken2() async throws->String?{
        let url="http://localhost:58000/api/v1/ticket"
        var retorno="TokenError"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Agregar las cabeceras HTTP necesarias
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parametros: [String: String] = [
            "username": "cisco",
            "password": "cisco"
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parametros, options: [])


            request.httpBody = jsonData

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                throw WelcomePT2Error.TokenGenerationError
            }
            let ticketResponse = try? JSONDecoder().decode(TicketResponse.self, from: data)
            retorno = ticketResponse?.response.serviceTicket ?? "TokenError"
            
            return retorno

        } catch {
           print("Error al obtener token: \(error)")
        }
        return retorno
    }
    static func getHosts(token:String) async throws->[ResponsePT]{
        let url="http://localhost:58000/api/v1/assurance/health"
        let baseURL = URL(string: url)
        var request = URLRequest(url: baseURL!)
        //request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WelcomePT2Error.HealthNotFound
        }
        let welcomeInstance = try JSONDecoder().decode(WelcomePT2.self, from: data)
        return welcomeInstance.response
        
    }
}
