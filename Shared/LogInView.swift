//
//  LogInView.swift
//  SpiritPointsiOSApp
//
//  Created by Rosalie Wessels on 3/24/21.
//

import SwiftUI

struct LogInView: View {
    @State var username = ""
    @State var password = ""
    var body: some View {
        
        VStack{
            HStack {
                Text ("Username")
                    .font(.title)
                    .bold()
                Spacer()
            }
            .padding(.leading)
            
            TextField("Username", text: $username).padding(.horizontal)
            
            HStack {
                Text("Password").font(.title)
                    .bold()
                Spacer()
                
                
            }.padding(.leading)
            
            TextField("Password", text: $password)
                .padding(.horizontal)
            
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Submit").foregroundColor(.green)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
            )
            
        }
            .navigationBarTitle("Admin Login", displayMode: .inline)
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
