//
//  ContentView.swift
//  Shared
//
//  Created by Rosalie Wessels on 11/23/20.
//

import SwiftUI

struct ContentView: View {
    @State var seventhGradePoints = 10
    @State var eightGradePoints = 8
    @State var ninthGradePoints = 14
    @State var tenthGradePoints = 16
    @State var eleventhGradePoints = 15
    @State var twelfthGradePoints = 4
    
    var body: some View {
        ScrollView {
            VStack{
                Text("Corona Point App")
                    .foregroundColor(.green)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black).padding()
                
                //Cards
                Text("Junior High:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                
                PointsCard(grade: "Seventh Grade", points: seventhGradePoints)
                
                PointsCard(grade: "Eighth Grade", points: eightGradePoints)
                
                Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
        
                PointsCard(grade: "Freshman", points: ninthGradePoints)
                
                PointsCard(grade: "Sophomores", points: tenthGradePoints)
                
                PointsCard(grade: "Juniors", points: eleventhGradePoints)
                
                PointsCard(grade: "Senior", points: twelfthGradePoints)
                
                //Add Bar Graph here:
                
                
                //Add Upcoming Events section here:
                
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
    @State var changingPoints: String = ""
    var body: some View {
        
        VStack {
            
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width:358, height:65)
                    .cornerRadius(10)
                    .padding(-30)
                
                Text(grade).font(.body).fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .font(.system(.title2,design: .rounded))
            }
            
            
            VStack (alignment: .leading){
                
                Text("Number of Points:")
                    .bold()
                Text(String(points))
                
                HStack{
                    
                    TextField("# of points added", text:$changingPoints)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action:{ add_points (points1: points)}) {
                        ZStack {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width:40, height:40)
                                .cornerRadius(10)
                            
                            Text("+")
                                .foregroundColor(.white)
                                .font(.system(size:35))
                                .bold()
                                .padding(.bottom, 5)
                        }
                    }
                
                    Button(action:{sub_points(points1: points)}){
                        ZStack {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width:40, height:40)
                                .cornerRadius(10)
                            
                            Text("-")
                                .foregroundColor(.white)
                                .font(.system(size:35))
                                .bold()
                                .padding(.bottom, 5)
                        }
                    }
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth:.infinity, minHeight: 200)
            
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.green, lineWidth: 8))
            .padding(.horizontal)
        }
        .padding()
    }
    func add_points(points1: Int) {
        points = points + 10
    }

    func sub_points(points1: Int) {
        points = points - 10
    }
}
