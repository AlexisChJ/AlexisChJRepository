import SwiftUI
import Charts
//codigo checado por alexis y patricio
struct TemperatureLineChartUIView: View {
    var selectedVariables: [String]
    var updateSelectedVariables: (String) -> Void
    @State private var temperatureData: [Temperature] = []
    @State private var humidityData: [Humidity] = []
    @State private var windData: [Wind] = []
    @State private var apData: [AP] = []
    var projectID: Int
    
    var body: some View {
        VStack {
            Text("Environmental Data Over Time")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            
            Chart {
                ForEach(selectedVariables, id: \.self) { variable in
                    if variable == "Temperature" {
                        ForEach(temperatureData) { reading in
                            LineMark(
                                x: .value("Time", reading.timeStamp),
                                y: .value("Temperature", Double(reading.value)),
                                series: .value("Temperatures", "A")
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            .foregroundStyle(.blue.gradient)
                            .foregroundStyle(.blue)
                        }
                    } else if variable == "Humidity" {
                        ForEach(humidityData) { reading in
                            LineMark(
                                x: .value("Time", reading.timeStamp),
                                y: .value("Humidity", Double(reading.value)),
                                series: .value("Humidity", "B")
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            .foregroundStyle(.red.gradient)
                            .foregroundStyle(.red)
                        }
                    } else if variable == "Wind" {
                        ForEach(windData) { reading in
                            LineMark(
                                x: .value("Time", reading.timeStamp),
                                y: .value("Wind", Double(reading.value)),
                                series: .value("Wind", "C")
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            .foregroundStyle(.green.gradient)
                            .foregroundStyle(.green)
                        }
                    } else if variable == "Atmospheric Pressure" {
                        ForEach(apData) { reading in
                            LineMark(
                                x: .value("Time", reading.timeStamp),
                                y: .value("Atmospheric Pressure", Double(reading.value)),
                                series: .value("Atmospheric Pressure", "D")
                            )
                            .interpolationMethod(.catmullRom)
                            .lineStyle(StrokeStyle(lineWidth: 2))
                            .foregroundStyle(.purple.gradient)
                            .foregroundStyle(.purple)
                        }
                    }
                }
            }
            .chartYScale(domain: 0...200)
            .chartXAxisLabel("Date&time", position: .bottom)
            .chartYAxisLabel("Value", position: .leading)
            .padding()
            HStack {
                ForEach(selectedVariables, id: \.self) { variable in
                    HStack {
                        Circle()
                            .fill(colorForVariable(variable))
                            .frame(width: 10, height: 10)
                        Text(variable)
                            .font(.caption)
                            .padding(.trailing, 10)
                    }
                }
            }
            .padding(.top, 8)
        }
        
        .onAppear {
            fetchAllData()
        }
        .onChange(of: selectedVariables) { newSelection in
            fetchAllData()
        }
        
    }
    func colorForVariable(_ variable: String) -> Color {
        switch variable {
        case "Temperature":
            return .blue
        case "Humidity":
            return .red
        case "Wind":
            return .green
        case "Atmospheric Pressure":
            return .purple
        default:
            return .black
        }
    }
    private func fetchAllData() {
        TemperatureService.fetchTemperatureData(for: projectID) { data in
            DispatchQueue.main.async {
                self.temperatureData = data
            }
        }
        HumidityService.fetchHumidityData(for: projectID) { data in
            DispatchQueue.main.async {
                self.humidityData = data
            }
        }
        WindService.fetchWindData(for: projectID) { data in
            DispatchQueue.main.async {
                self.windData = data
            }
        }
        APService.fetchAPData(for: projectID) { data in
            DispatchQueue.main.async {
                self.apData = data
            }
        }
    }
    
}
