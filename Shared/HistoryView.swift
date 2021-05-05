//
//  HistoryView.swift
//  SpiritPointsiOSApp
//
//  Created by Rosalie Wessels on 4/27/21.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        ScrollView{
            VStack {
                Text("History")
                        .foregroundColor(.green)
                        .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black).padding()
                Text("Date: Fri Mar 19 2021 14:53:22 GMT-0700 (PDT) Reason: Green and gold spirit day Gold cohort User: 22akamangar@pinewood.edu Grade: 10 Points: 4").font(.headline)
        }
        
        }
        
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
