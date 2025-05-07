//
//  SideBar.swift
//  DALT-BLINDED
//
//  Created by Alexis on 06/04/23.
//

import SwiftUI

struct SideBar: View {
    var body: some View {
        NavigationView{
            List{
                //PROFILE
                NavigationLink(destination: Profile()){
                    HStack{
                        Image(systemName: "person.text.rectangle")
                        Text("Your profile").font(.title2)
                    }
                }.padding()
                
                //EDIT INFO
                NavigationLink(destination: EditInfo()){
                    HStack{
                        Image(systemName: "gear")
                            .foregroundColor(.gray)
                        Text("Edit your information").font(.title2)
                    }
                }.padding()
                
                //CAMERA
                NavigationLink(destination: Camera()){
                    HStack{
                        Image(systemName: "camera.on.rectangle")
                            .foregroundColor(.green)
                        Text("Camera").font(.title2)
                    }
                }.padding()
                
                //PHOTO
                NavigationLink(destination: Photo()){
                    HStack{
                        Image(systemName: "photo")
                            .foregroundColor(.blue)
                        Text("Photo").font(.title2)
                    }
                }.padding()
    
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("DALT-BLINDED").font(.largeTitle)
        }
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
