//
//  Profile.swift
//  DALT-BLINDED
//
//  Created by Alexis on 04/04/23.
//

import SwiftUI

struct Profile: View {
    @ObservedObject var userSettings = UserSettings()
    var body: some View {
        VStack{
            VStack(alignment: .center){
                Image(systemName: "person.fill.viewfinder")
                Text("Name / Nickname: \(userSettings.userName)").padding()
                Text("Color with most trouble with: \(userSettings.userType)")
                
            }.font(.largeTitle)
        }
        
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
