//
//  SpiritPointsiOSAppApp.swift
//  Shared
//
//  Created by Rosalie Wessels on 11/23/20.
//

import SwiftUI
import Firebase

@main
struct SpiritPointsiOSAppApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
