//
//  OverallHealth.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 13/10/24.
//

import Foundation

// MARK: - OverallHealthJSON
class OverallHealthJSON: Codable {
    let healthyClient, healthyNetworkDevice, numApplicationPolicies, numLicensedRouters: String
    let numLicensedSwitches, numNetworkDevices, numUnreachable: String

    init(healthyClient: String, healthyNetworkDevice: String, numApplicationPolicies: String, numLicensedRouters: String, numLicensedSwitches: String, numNetworkDevices: String, numUnreachable: String) {
        self.healthyClient = healthyClient
        self.healthyNetworkDevice = healthyNetworkDevice
        self.numApplicationPolicies = numApplicationPolicies
        self.numLicensedRouters = numLicensedRouters
        self.numLicensedSwitches = numLicensedSwitches
        self.numNetworkDevices = numNetworkDevices
        self.numUnreachable = numUnreachable
    }
}

enum OverallHealthJSONError: Error, LocalizedError {
    case notConnected
    case dataNotFound
    case tokenGenerationError
}

extension OverallHealthJSON {
    static func getToken() async throws -> String {
        let url = "http://localhost:58000/api/v1/ticket"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: String] = [
            "username": "cisco",
            "password": "cisco"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                throw OverallHealthJSONError.tokenGenerationError
            }
            
            if let ticketResponse = try? JSONDecoder().decode(TicketResponse.self, from: data) {
                return ticketResponse.response.serviceTicket
            } else {
                throw OverallHealthJSONError.tokenGenerationError
            }
        } catch {
            throw OverallHealthJSONError.tokenGenerationError
        }
    }

    static func getOverallHealth(token: String) async throws -> OverallHealthJSON {
        let url = "http://localhost:58000/api/v1/network-health"
        var request = URLRequest(url: URL(string: url)!)
        request.addValue(token, forHTTPHeaderField: "X-Auth-Token")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw OverallHealthJSONError.dataNotFound
        }
        do {
            let overallHealthData = try JSONDecoder().decode(OverallHealthJSON.self, from: data)
            return overallHealthData
        } catch {
            throw OverallHealthJSONError.dataNotFound
        }
    }
}

