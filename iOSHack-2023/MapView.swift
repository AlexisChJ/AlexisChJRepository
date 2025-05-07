import MapKit
import SwiftUI
//mapa y datos
struct zoom:Identifiable{
    let id = UUID()
    var latitude = 19.283977
    var longitude = -99.135968
    var deltaLatitude = 0.01
    var deltaLongitude = 0.01
}
//struct mapa
struct MapView: View {
    //variable coordinates
    @State var region: MKCoordinateRegion = .init(
        center: CLLocationCoordinate2D(latitude: 19.283977,longitude: -99.135968),span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02))
    let points = [zoom(latitude: 19.283977,longitude: -99.135968,deltaLatitude: 0.02,deltaLongitude: 0.02)]
    //view mapa
    var body: some View {
        ZStack{
            Map(coordinateRegion: $region, annotationItems: points){ place in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude))
            }.ignoresSafeArea(.all,edges: .all)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        //zoom in
                        region.span.latitudeDelta *= 0.04
                        region.span.longitudeDelta *= 0.4
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).frame(width: 35, height: 35)
                            Image(systemName: "plus").foregroundColor(.white)
                        }
                    }
                    Button(action: {
                        //zoom out
                        region.span.longitudeDelta=max(region.span.longitudeDelta*1.91,0.001)
                        region.span.latitudeDelta=max(region.span.latitudeDelta*1.91,0.001)
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).frame(width: 35, height: 35)
                            Image(systemName: "minus").foregroundColor(.white)
                        }
                    }
                }.padding()
            }
        }
        
        
        
    }
}
//preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

