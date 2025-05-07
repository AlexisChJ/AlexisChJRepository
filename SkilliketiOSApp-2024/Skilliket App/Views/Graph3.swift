import SwiftUI
import Charts

struct WindLineChartUIView: View {
    @State private var windData: [Wind] = []
    @State private var selectedReading: Wind?
    var projectID: Int
    var body: some View {
        VStack{
            Text("Wind")
                .font(.title)
                .padding()
            
            if !windData.isEmpty {
                Chart {
                    ForEach(windData) { reading in
                        LineMark(
                            x: .value("Time", reading.timeStamp),
                            y: .value("Wind", Double(reading.value))
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYScale(domain: 0...100)
                .chartXAxisLabel("Date&time", position: .bottom)
                .chartYAxisLabel("m/s", position: .leading)
                .padding()
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x),
                                           let closestReading = windData.min(by: {
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
                    Text("Wind: \(selectedReading.value) m/s")
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
            WindService.fetchWindData(for: projectID) { data in
                DispatchQueue.main.async {
                    self.windData = data
                }
            }
        }

    }
}

#Preview {
    WindLineChartUIView(projectID: 1)
}
