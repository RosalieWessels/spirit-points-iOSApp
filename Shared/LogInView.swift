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
    @State var showSuccessfulAlert = false
    @State var showUnsuccessfulAlert = false
    
    var body: some View {
        
        VStack{
            Spacer()
            HStack {
                Text ("Username")
                    .font(.title)
                    .bold()
                Spacer()
            }
            
            .padding(.leading)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom,50)
            
            HStack {
                Text("Password").font(.title)
                    .bold()
                Spacer()
                
                
            }.padding(.leading)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom,50)
            
            
            
            Button(action: {checkLogin()}) {
                Text("Submit").foregroundColor(.green)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
            )
            Spacer()
        }
        .alert(isPresented: $showSuccessfulAlert) {
            Alert(
                title: Text("Login successful!"),
                message: Text("Your login was successful!"),
                dismissButton: .default(Text("Take me back to the home screen")) {
                    print("Log In")
                }
            )
        }
        
        .navigationBarTitle("Admin Login", displayMode: .inline)
    }
    
    func checkLogin() {
        if username == "admin123" && password == "password" {
            print("That checks out")
            showSuccessfulAlert=true
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
