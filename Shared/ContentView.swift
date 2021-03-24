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
    @State var eightGradePoints = 32
    @State var ninthGradePoints = 10
    @State var tenthGradePoints = 13
    @State var eleventhGradePoints = 1
    @State var twelfthGradePoints = 4

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
                    PointsCard(grade: "Seventh Grade", points: seventhGradePoints, is_winner: isWinnerJH(grade:"Seventh Grade"))
                }
                
                PointsCard(grade: "Eighth Grade", points: eightGradePoints, is_winner: isWinnerJH(grade:"Eighth Grade"))
                
                Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
        
                PointsCard(grade: "Freshman", points: ninthGradePoints, is_winner: isWinnerHS(grade:"Freshman"))
                
                PointsCard(grade: "Sophomores", points: tenthGradePoints, is_winner: isWinnerHS(grade:"Sophomores"))
                
                PointsCard(grade: "Juniors", points: eleventhGradePoints, is_winner: isWinnerHS(grade:"Juniors"))
                
                PointsCard(grade: "Seniors", points: twelfthGradePoints, is_winner: isWinnerHS(grade:"Seniors"))
                
                //Add Bar Graph here:
                
                
                
                
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
                
                NavigationLink(destination: LogInView()) {
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
            
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    //Finding grade with the least amount of points (current winners)
    func isWinnerHS(grade: String) -> Bool{
        var winnerHS = ""
        if ninthGradePoints <= tenthGradePoints && ninthGradePoints <= eleventhGradePoints && ninthGradePoints <= twelfthGradePoints{
            winnerHS = "Freshman"
        }
        else if tenthGradePoints <= ninthGradePoints && tenthGradePoints <= eleventhGradePoints && tenthGradePoints <= twelfthGradePoints{
            winnerHS = "Sophomores"
        }
        else if eleventhGradePoints <= ninthGradePoints && eleventhGradePoints <= tenthGradePoints && eleventhGradePoints <= twelfthGradePoints {
            winnerHS = "Juniors"
        }
        else {
            winnerHS = "Seniors"
        }
        return grade == winnerHS
    }
    
    func isWinnerJH(grade: String) -> Bool{
        var winnerJH = ""
        if seventhGradePoints <= eightGradePoints{
            winnerJH = "Seventh Grade"
        }
        else {
            winnerJH = "Eighth Grade"
        }
        print(winnerJH)
        print(winnerJH == grade)
        return grade == winnerJH
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
    @State var is_winner: Bool
    
    @State var changingPoints: String = ""
    @State var isAdminUser: Bool = true
    
    var body: some View {
        VStack {
            
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width:352, height:65)
                    .padding(-30)
                
                HStack {
                    if is_winner {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                    }
                    
                    Text(grade).font(.body).fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .font(.system(.title2,design: .rounded))
                }
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

