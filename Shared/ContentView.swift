//
//  ContentView.swift
//  Shared
//
//  Created by Rosalie Wessels on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack{
                Text("Corona Point Website")
                    .foregroundColor(.green)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black).padding()
                
                Text("Junior High:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                
                PointsCard(grade: "Seventh Grade", points: 10)
                
                PointsCard(grade: "Eighth Grade", points: 10)
                
                Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
        
                PointsCard(grade: "Freshman", points: 10)
                
                PointsCard(grade: "Sophomores", points: 10)
                
                PointsCard(grade: "Juniors", points: 10)
                
                PointsCard(grade: "Senior", points: 10)
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PointsCard: View {
    @State var grade: String
    @State var points: Int
    var body: some View {
        VStack{
            HStack{
                Button(action:{ add_points (points1: points)}) {Image("Plus_button").resizable().aspectRatio(contentMode:.fit).frame(width: 50, height: 50)
                }
            
                Button(action:{sub_points(points1: points)}){Image("Sub_button").resizable().aspectRatio(contentMode:.fit).frame(width: 70, height: 70)
                }
            }
            Text(grade).font(.body).fontWeight(.heavy)
            Text("Number of Points: \(points)")
        }
        .padding()
        .frame(minWidth: 0, maxWidth:.infinity, minHeight: 200)
        
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 8))
        .padding(.horizontal)
        .padding()
    }
    func add_points(points1: Int) {
        points = points + 10
    }

    func sub_points(points1: Int) {
        points = points - 10
    }
}
