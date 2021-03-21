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
    
    @State var winningGrade: String = ""
    
    @State var db = Firestore.firestore()
    
    @State var showAlert = false
    
    @State var upcomingEventsList = ["Crazy Hair Day (February 8th)", "Talent Show", "Valentine's Exchange", "Spring Break", "Green/Gold dress day"]
    
    var body: some View {
        ScrollView {
            VStack{
                Text("Corona Points App")
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
            
            
            VStack (spacing: 0) {
                //Add Upcoming Events section here:
                Text("Upcoming Events - Get Hyped")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 1) {
                    ForEach(0..<upcomingEventsList.count) { index in
                        Text("\(upcomingEventsList[index])")
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .background(Color.white)
                        
                    }
                }
                .background(Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                
                
            }
            Button(action: {
                showAlert=true
            }) {
                Text("Admin")
                    .foregroundColor(.green)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
            
            )
        }
        .onAppear(perform: {
            getPoints()
            findWinningGradeHS()
        })
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Log In"),
                message: Text("Text 1"),
                primaryButton: .default(Text("Log In")) {
                    print("Log In")
                },
                secondaryButton: .cancel())
        }
    
    }
    
    //Finding grade with the least amount of points (current winners)
    func findWinningGradeHS(){
        var winnerHS = ""
        if ninthGradePoints >= tenthGradePoints {
            winnerHS = "ninthGrade"
        }
        print(winnerHS)
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
    @State var isAdminUser: Bool = true
    var body: some View {
        
        VStack {
            
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width:352, height:65)
                    .padding(-30)
                
                Text(grade).font(.body).fontWeight(.heavy)
                    .foregroundColor(Color.white)
                    .font(.system(.title2,design: .rounded))
            }
            
            
            VStack (alignment: .leading){
                
                Text("Number of Points:")
                    .bold()
                    .padding(.bottom, 5)
                
                Text(String(points))
                
                if isAdminUser {
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
            }
            .padding()
            .frame(minWidth: 0, maxWidth:.infinity, minHeight: 200)
            
            .overlay(Rectangle().stroke(Color.green, lineWidth: 2))
            .padding(.horizontal)
        }
        .padding()
    }
    func add_points(points1: Int) {
        guard let changingPoints = Int(changingPoints) else { return }
        points = points + changingPoints
    }

    func sub_points(points1: Int) {
        guard let changingPoints = Int(changingPoints) else { return }
        points = points - changingPoints
    }
}

