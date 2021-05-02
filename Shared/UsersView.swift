//
//  UsersView.swift
//  SpiritPointsiOSApp
//
//  Created by Rosalie Wessels on 5/1/21.
//

import SwiftUI

struct UsersView: View {
    var body: some View {
        VStack {
            Text("Manage Users:")
                .font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
            VStack {
                Text("jbruno@pinewood.edu")
                Text("hmark@pinewood.edu")
                Text("glemmon@pinewood.edu")
                Text("etyson@pinewood.edu")
                Text("23rwessels@pinewood.edu")
                Text("22mpistelak@pinewood.edu")
            }
            VStack {
                Text("22awong@pinewood.edu")
                Text("22akamanger@pinewood.edu")
                Text("21vreed@pinwood.edu")
                Text("21sking@pinewood.edu")
                Text("21mrodriguezsteube@pinewood.edu")
                Text("21alevy@pinewood.edu")
            }
            
            Text("Delete my account")
                .font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
            Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Delete")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.red)
            .cornerRadius(10)
        }
    }
}

struct UsersView_Previews: PreviewProvider {
    static var previews: some View {
        UsersView()
    }
}
