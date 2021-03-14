//
//  ContentView.swift
//  Shared
//
//  Created by Rosalie Wessels on 11/23/20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var seventhGradePoints = 0
    @State var eightGradePoints = 8
    @State var ninthGradePoints = 14
    @State var tenthGradePoints = 16
    @State var eleventhGradePoints = 15
    @State var twelfthGradePoints = 4
    
    @State var db = Firestore.firestore()
    
    var body: some View {
        ScrollView {
            VStack{
                Text("Corona Point App")
                    .foregroundColor(.green)
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black).padding()
                
                //Cards
                Text("Junior High:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                
                if seventhGradePoints != 0 {
                    PointsCard(grade: "Seventh Grade", points: seventhGradePoints)
                }
                
                PointsCard(grade: "Eighth Grade", points: eightGradePoints)
                
                Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
        
                PointsCard(grade: "Freshman", points: ninthGradePoints)
                
                PointsCard(grade: "Sophomores", points: tenthGradePoints)
                
                PointsCard(grade: "Juniors", points: eleventhGradePoints)
                
                PointsCard(grade: "Senior", points: twelfthGradePoints)
                
                //Add Bar Graph here:
                
                
                
                
            }
            VStack {
                //Add Upcoming Events section here:
                Text("Upcoming Events - Get Hyped")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .padding()
                
                UpcomingEventsView(text: "Crazy Hair Day")
                
                
                UpcomingEventsView(text: "Talent Show")
                
                UpcomingEventsView(text: "Valentine's Exchange")
                
                
            }
        }
        .onAppear(perform: {
            getPoints()
        })
    }
    
    func getPoints() {
        let docRef = db.collection("points").document("7th Grade")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                if let points = document.get("points") as? Int {
                    print("FOUND THE DATA")
                    seventhGradePoints = points
                    print(seventhGradePoints)
                }
            } else {
                print("Document does not exist")
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
                RoundedRectangle(cornerRadius:20)
                    .fill(Color.green)
                    .frame(width:358, height:65)
                    .cornerRadius(10)
                    .padding(-30)
                
                Text(grade).font(.body).fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .font(.system(.title2,design: .rounded))
            }
            .padding(.bottom, -40)
            
            
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

struct UpcomingEventsView: View {
    @State var text : String
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(text)
                .font(.system(.headline))
                .padding(.vertical)
            
            Spacer()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
