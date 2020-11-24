//
//  ContentView.swift
//  Shared
//
//  Created by Rosalie Wessels on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Corona Point Website").foregroundColor(.green).font(.system(.largeTitle, design: .rounded)).fontWeight(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
