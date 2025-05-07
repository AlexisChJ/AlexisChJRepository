//
//  NetworkViewModel.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 14/10/24.
//

import Foundation

class NetworkViewModel: ObservableObject {
    @Published var networkDeviceData: [NetworkDevicePercentage] = []
    
    // Esta función se puede llamar después de obtener la respuesta de la API
    func fetchNetworkDevices() async {
        do {
            let token = try await WelcomePT2.getToken2()
            let responses = try await WelcomePT2.getHosts(token: token!)
            self.networkDeviceData = extractNetworkDeviceData(from: responses)
        } catch {
            //print("Error fetching network devices: \(error)")
        }
    }
    
    // Función para extraer datos de network devices
    private func extractNetworkDeviceData(from response: [ResponsePT]) -> [NetworkDevicePercentage] {
        return response.compactMap { response in
            guard let percentage = Double(response.networkDevices.totalPercentage) else {
                return nil // Ignora si no se puede convertir a Double
            }
            let date = ISO8601DateFormatter().date(from: response.timestamp) ?? Date()
            return NetworkDevicePercentage(timeStamp: date, totalPercentage: percentage)
        }
    }
}

