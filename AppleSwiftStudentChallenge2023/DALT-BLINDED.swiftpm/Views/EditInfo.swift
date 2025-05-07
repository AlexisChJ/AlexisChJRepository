//CODE
import SwiftUI
//------------------VIEW----------------------------
struct EditInfo: View {
    //------------User Default settings-----------------
    @ObservedObject var userSettings = UserSettings()
    //---------------------UI---------------------
    var body: some View {
        VStack{
            Text("YOUR INFORMATION").font(.largeTitle).fontWeight(.semibold).foregroundColor(Color("A")).multilineTextAlignment(.center)
            Form{
                
                //INFORMATION OF THE USER
                Section(header: HStack{
                    Image(systemName: "person.crop.circle.dashed")
                    Text("PROFILE").font(.title3)
                }){
                    VStack{
                        //NAME
                        HStack{
                            TextField("Name / Nickname", text: $userSettings.userName)
                        }.padding()
                        Divider()
                        //COLORS
                        HStack{
                            Picker(selection: $userSettings.userType, label: Text("Select the color you have more trouble identifying: ")){
                                ForEach(userSettings.userTypes, id: \.self) { userType in
                                    Text(userType)
                                }
                            }.padding()
                            
                        }
                        Divider()
                        HStack{
                            Text("Note: This app intends to help colorblind people to see the colorful world in which we live on, remember going to the ophtalmologist for a detailed and accurate diagnistic.")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                                .multilineTextAlignment(.center)
                        }.padding()
                        //SAVE BUTTON
                        
                    }
                }
            }
        }
        .accentColor(.blue)
    }
}

//--------------PREVIEW-------------
struct EditInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditInfo()
    }
}
