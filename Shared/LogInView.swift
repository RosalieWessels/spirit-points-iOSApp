//
//  LogInView.swift
//  SpiritPointsiOSApp
//
//  Created by Tech Club on 3/24/21.
//

import SwiftUI
import Firebase
import Combine

struct LogInView: View {
    @ObservedObject var model : ModelData
    @State var showSuccessfulAlert = false
    @State var showUnsuccessfulAlert = false
    
    var body: some View {
        VStack{
            HStack {
                Spacer()
                Button(action: {
                    model.isLogIn.toggle()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.title)
                }
                .padding()
            }
            Spacer()
            HStack {
                Text ("Username")
                    .font(.title)
                    .bold()
                Spacer()
            }
            
            .padding(.leading)
            
            TextField("Username", text: $model.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .textCase(.lowercase)
                .padding(.bottom,50)
            
            HStack {
                Text("Password").font(.title)
                    .bold()
                Spacer()
                
                
            }.padding(.leading)
            
            SecureField("Password", text: $model.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.bottom,50)
                .textCase(.lowercase)
                .alert(isPresented: $showUnsuccessfulAlert){
                    Alert(
                        title: Text("Login Unsuccessful"),
                        message: Text("Your login was unsuccessful, please check your username or password."),
                        dismissButton:
                            .default(Text("Close and Try Again")) {
                                print("Try Again")
                            }
                    )
                }
            
            
            
            Button(action: model.login) {
                Text("Submit").foregroundColor(.green)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
            )
//            .alert(isPresented: $model.alert, content: {
//                Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok")))
//            })

            
            Spacer()
        }
        .navigationBarTitle("Admin Login", displayMode: .inline)
        .alert(isPresented: $model.alert, content: {
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                
                if model.alertMsg == "You are logged in!"{
                    model.isLogIn.toggle()
                    
                }
                
            }))
        })
    }
}


class ModelData : ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLogIn = false
    
    @Published var alert = false
    @Published var alertMsg = ""
    
    @AppStorage("log_Status") var status = DefaultStatus.status
    
    @Published var isLoading = false
    
    func login() {
        
        if email == "" || password == "" {
            self.alertMsg = "Please fill the text boxes"
            self.alert.toggle()
            return
        }
        
        withAnimation {
            self.isLoading.toggle()
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            withAnimation {
                self.isLoading.toggle()
            }
            
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            let user = Auth.auth().currentUser
            print("Logged in!")
            
            
            
            withAnimation {
                
                self.status = true
                self.alertMsg = "You are logged in!"
                self.alert.toggle()
                let contentview = ContentView()
                contentview.checkState()
                
            }
            
        }
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        
        withAnimation {
            self.status = false
        }
        
        email = ""
        password = ""
    }
}

struct LoadingView: View {
    @State var animation = false
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color.black, lineWidth: 8)
                .frame(width: 75, height: 75)
                .rotationEffect(.init(degrees: animation ? 360 : 0))
                .padding(50)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all, edges: .all))
        .onAppear(perform: {
            withAnimation(Animation.linear(duration: 1)) {
                animation.toggle()
            }
        })
    }
}

enum DefaultStatus {
    static let status = false
}
