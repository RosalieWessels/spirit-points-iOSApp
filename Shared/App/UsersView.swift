//
//  UsersView.swift
//  SpiritPointsiOSApp
//
//  Created by Tech Club on 5/1/21.
//

import SwiftUI
import Firebase
import grpc

struct UsersView: View {
    @State var users : [String] = ["fake"]
    @State var db = Firestore.firestore()
    
    var body: some View {
        VStack {
            Text("Current Users:")
                .font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
            
            if users[0] != "fake" {
                VStack {
                    ForEach(0..<users.count) { index in
                        Text("\(users[index])")
                    }
                }
            }
        }
        .onAppear(perform: {
            getUsers()
        })
    }
    
    func getUsers() {
        db.collection("users")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if let email = document.get("email") as? String {
                            users.append(email)
                        }
                    }
                    users.remove(at: 0)
                }
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
