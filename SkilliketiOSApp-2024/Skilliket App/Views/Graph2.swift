import SwiftUI
import Charts

struct HumidityLineChartUIView: View {
    @State private var humidityData: [Humidity] = []
    @State private var selectedReading: Humidity?
    var projectID: Int
    var body: some View {
        VStack{
            Text("Humidity")
                .font(.title)
                .padding()
            
            if !humidityData.isEmpty {
                Chart {
                    ForEach(humidityData) { reading in
                        LineMark(
                            x: .value("Time", reading.timeStamp),
                            y: .value("Humidity", Double(reading.value))
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYScale(domain: 0...100)
                .chartXAxisLabel("Date&time", position: .bottom)
                .chartYAxisLabel("%", position: .leading)
                .padding()
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x),
                                           let closestReading = humidityData.min(by: {
                                               abs($0.timeStamp.timeIntervalSince(date)) <
                                               abs($1.timeStamp.timeIntervalSince(date))
                                           }) {
                                            selectedReading = closestReading
                                        }
                                    }
                            )
                    }
                }
                
                if let selectedReading = selectedReading {
                    Text("Humidity: \(selectedReading.value) %")
                        .font(.headline)
                    Text("Date: \(selectedReading.timeStamp.formatted(date: .numeric, time: .shortened))")
                        .font(.subheadline)
                        .padding(.top, 4)
                }
            } else {
                Text("Loading data...")
            }
        }
        .onAppear {
            HumidityService.fetchHumidityData(for: projectID) { data in
                DispatchQueue.main.async {
                    self.humidityData = data
                }
            }
        }

    }
}

#Preview {
    HumidityLineChartUIView(projectID: 1)
}
