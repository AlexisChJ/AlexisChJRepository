import SwiftUI
import Charts

struct APLineChartUIView: View {
    @State private var apData: [AP] = []
    @State private var selectedReading: AP?
    var projectID: Int
    var body: some View {
        VStack{
            Text("Atmospheric Pressure")
                .font(.title)
                .padding()
            
            if !apData.isEmpty {
                Chart {
                    ForEach(apData) { reading in
                        LineMark(
                            x: .value("Time", reading.timeStamp),
                            y: .value("AP", Double(reading.value))
                        )
                        .interpolationMethod(.catmullRom)
                    }
                }
                .chartYScale(domain: 0...200)
                .chartXAxisLabel("Date&time", position: .bottom)
                .chartYAxisLabel("kPa", position: .leading)
                .padding()
                .chartOverlay { proxy in
                    GeometryReader { geo in
                        Rectangle().fill(Color.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let location = value.location
                                        if let date: Date = proxy.value(atX: location.x),
                                           let closestReading = apData.min(by: {
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
                    Text("AP: \(selectedReading.value) kPa")
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
            APService.fetchAPData(for: projectID) { data in
                DispatchQueue.main.async {
                    self.apData = data
                }
            }
        }

    }
}

#Preview {
    APLineChartUIView(projectID: 1)
}
