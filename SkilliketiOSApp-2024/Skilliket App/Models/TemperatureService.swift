//
//  TemperatureService.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 15/10/24.
//

import Foundation
import Foundation


struct TemperatureService {
    
    static func fetchTemperatureData(for projectID: Int, completion: @escaping ([Temperature]) -> Void) {
            guard let url = URL(string: "http://localhost:8765/devices/") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    //print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let welcome = try JSONDecoder().decode(WelcomeVAR.self, from: data)
                    let filteredDevices = welcome.devices.filter { String($0.projectID) == String(projectID) }
                    let temperatureData = convertToTemperatureArray(devices: filteredDevices)
                    completion(temperatureData)
                } catch {
                    //print("Error decoding data: \(error.localizedDescription)")
                }
            }.resume()
        }

    private static func convertToTemperatureArray(devices: [Device]) -> [Temperature] {
        var temperatureData: [Temperature] = []
        
        for device in devices {
            for variable in device.environmentalVariables {
                if variable.name == .temperature {
                    if let date = parseDate(variable.date) {
                        let temperature = Temperature(value: Int(variable.value), timeStamp: date)
                        temperatureData.append(temperature)
                    }
                }
            }
        }

        
        return temperatureData
    }

    private static func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
}
