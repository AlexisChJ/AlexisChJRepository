//
//  TemperatureService.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 15/10/24.
//

import Foundation

// Servicio para obtener y procesar datos de temperatura desde el JSON
import Foundation

// Servicio para obtener y procesar datos de temperatura desde el JSON
struct HumidityService {
    
    // Define la función como estática para que puedas llamarla sin una instancia
    static func fetchHumidityData(for projectID: Int, completion: @escaping ([Humidity]) -> Void) {
        guard let url = URL(string: "http://localhost:8765/devices/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                //print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let welcome = try JSONDecoder().decode(WelcomeVAR.self, from: data)
                let filteredDevices = welcome.devices.filter { String($0.projectID) == String(projectID) }
                let humidityData = convertToHumidityArray(devices: filteredDevices)
                completion(humidityData)
            } catch {
                //print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }

    private static func convertToHumidityArray(devices: [Device]) -> [Humidity] {
        var humidityData: [Humidity] = []
        
        for device in devices {
            for variable in device.environmentalVariables {
                if variable.name == .humidity {
                    // Llama a parseDate con el valor de date directamente, sin .rawValue
                    if let date = parseDate(variable.date) {
                        let humidity = Humidity(value: Int(variable.value), timeStamp: date)
                        humidityData.append(humidity)
                    }
                }
            }
        }

        
        return humidityData
    }

    // Método estático para analizar la fecha de cada dato de temperatura
    private static func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
}
