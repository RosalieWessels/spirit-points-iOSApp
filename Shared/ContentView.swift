//
//  ContentView.swift
//  Shared
//
//  Created by Rosalie Wessels on 11/23/20.
//

import SwiftUI
import Firebase
import SwiftUICharts

struct ContentView: View {
    @State var seventhGradePoints = -1
    @State var eighthGradePoints = -1
    @State var ninthGradePoints = -1
    @State var tenthGradePoints = -1
    @State var eleventhGradePoints = -1
    @State var twelfthGradePoints = -1

    @State var isAdmin = false
    @State var db = Firestore.firestore()
    
    @State var newUpcomingEvent = ""
    
    
    @State var upcomingEventsList = ["Crazy Hair Day (February 8th)", "Talent Show", "Valentine's Exchange", "Spring Break", "Green/Gold dress day"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack (spacing: 25){
                        VStack {
                            Text("Corona Points App")
                            .foregroundColor(.green)
                            .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.black).padding()
                            
                            Image("panthers").resizable().aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width - 200)
                        }
                        
                        
                        //Cards
                        Text("Junior High:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                    
                        if seventhGradePoints != -1 {
                        PointsCard(grade: "7th Grade", points: seventhGradePoints, is_winner: isWinnerJH(grade:"Seventh Grade"), isAdmin: isAdmin)
                    }
                    
                        if eighthGradePoints != -1 {
                        PointsCard(grade: "8th Grade", points: eighthGradePoints, is_winner: isWinnerJH(grade:"Eighth Grade"), isAdmin: isAdmin)
                    }
                    
                        Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
            
                        if ninthGradePoints != -1 {
                        PointsCard(grade: "Freshman", points: ninthGradePoints, is_winner: isWinnerHS(grade:"Freshman"), isAdmin: isAdmin)
                    }
                    
                    if tenthGradePoints != -1 {
                        PointsCard(grade: "Sophomores", points: tenthGradePoints, is_winner: isWinnerHS(grade:"Sophomores"), isAdmin: isAdmin)
                    }
                    
                    if eleventhGradePoints != -1 {
                        PointsCard(grade: "Juniors", points: eleventhGradePoints, is_winner: isWinnerHS(grade:"Juniors"), isAdmin: isAdmin)
                    }
                    
                    if twelfthGradePoints != -1 {
                        PointsCard(grade: "Seniors", points: twelfthGradePoints, is_winner: isWinnerHS(grade:"Seniors"), isAdmin: isAdmin)
                    }
                    Group{
                    //Add Bar Graph here:
                        let chartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Colors.OrangeStart, secondGradientColor: Color.green, textColor: Color.white, legendTextColor: Color.black, dropShadowColor: Color.white)

                    
                        Spacer()

                        if twelfthGradePoints != -1 && eleventhGradePoints != -1 && tenthGradePoints != -1 && ninthGradePoints != -1 && eighthGradePoints != -1 && seventhGradePoints != -1 {
                            BarChartView(data: ChartData(values: [("7th-grade", seventhGradePoints), ("8th-grade", eighthGradePoints), ("9th-grade", ninthGradePoints),
                                ("10th-grade", tenthGradePoints),
                                ("11th-grade", eleventhGradePoints),
                                ("12th-grade", twelfthGradePoints)]), title: "Corona-PointsBar Graph", legend: "Per Grade", style: chartStyle, form: ChartForm.extraLarge)

                        }

                        


                        Spacer()
                    
                    
                    
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
                            
                            if isAdmin {
                                HStack{
                                    Spacer()
                                    TextField("new upcoming event", text: $newUpcomingEvent)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()
                                    Button(action: {addUpcomingEvent()}){
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
                                    .padding()
                                    
                                    Spacer()
                                }
                            }
                        
                        
                    }
                    }
                    }
                }
                //end of vstack here
                 
                VStack {
                    
                    NavigationLink(destination: LogInView()) {
                        Text("Admin")
                            .foregroundColor(.green)
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
                    )
                    
                    if isAdmin {
                        NavigationLink(destination: HistoryView()) {
                            Text("History")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
                            )
                    }
                    
                    Text("@ Pinewood 2021 Tech Club").padding(.top, 20)
                    
                }
                .onAppear(perform: {
                    getPoints()
                    //findWinningGradeHS()
                })
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
    }
    
    func addUpcomingEvent(){
        upcomingEventsList.insert(newUpcomingEvent, at: 0)
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
        print(winnerHS)
        print(grade)
        print(winnerHS == grade)
        return grade == winnerHS
    }
    
    func isWinnerJH(grade: String) -> Bool{
        var winnerJH = ""
        if seventhGradePoints <= eighthGradePoints{
            winnerJH = "Seventh Grade"
        }
        else {
            winnerJH = "Eighth Grade"
        }
        return grade == winnerJH
    }
    
    func getPoints() {
        
        //7th Grade
        let docRefSeventhGrade = db.collection("points").document("7th Grade")

        docRefSeventhGrade.getDocument { (document, error) in
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
        
        //8th Grade
        let docRefEightGrade = db.collection("points").document("8th Grade")
        
        docRefEightGrade.getDocument { (document, error) in
            if let document = document, document.exists {
                if let points = document.get("points") as? Int {
                    print("FOUND THE DATA")
                    eighthGradePoints = points
                    print(eighthGradePoints)
                }
            } else {
                print("Document does not exist")
            }
        }
        
        // Freshman
        let docRefFreshman = db.collection("points").document("Freshman")
        
        docRefFreshman.getDocument { (document, error) in
            if let document = document, document.exists {
                if let points = document.get("points") as? Int {
                    print("FOUND THE DATA")
                    ninthGradePoints = points
                    print(ninthGradePoints)
                }
            } else {
                print("Document does not exist")
            }
        }
        
        // Sophomore
        let docRefSophomore = db.collection("points").document("Sophomores")
        
        docRefSophomore.getDocument { (document, error) in
            if let document = document, document.exists {
                if let points = document.get("points") as? Int {
                    print("FOUND THE DATA")
                    tenthGradePoints = points
                    print(tenthGradePoints)
                }
            } else {
                print("Document does not exist")
            }
        }
        
        // Juniors
        let docRefJunior = db.collection("points").document("Juniors")
        
        docRefJunior.getDocument { (document, error) in
            if let document = document, document.exists {
                if let points = document.get("points") as? Int {
                    print("FOUND THE DATA")
                    eleventhGradePoints = points
                    print(eleventhGradePoints)
                }
            } else {
                print("Document does not exist")
            }
        }
        
        // Seniors
        let docRefSenior = db.collection("points").document("Seniors")
        
        docRefSenior.getDocument { (document, error) in
            if let document = document, document.exists {
                if let points = document.get("points") as? Int {
                    print("FOUND THE DATA")
                    twelfthGradePoints = points
                    print(twelfthGradePoints)
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
    @State var db = Firestore.firestore()
    
    @State var changingPoints: String = ""
    @State var isAdmin: Bool
    
    var body: some View {
        VStack {
            
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: UIScreen.main.bounds.width - 60)
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
            .padding(.bottom)
            
            
            VStack (alignment: .leading){
                
                Spacer()
                        .frame(height: 30)
                
                HStack {
                    Text("Number of Points:")
                        .bold()
                        .padding(.bottom, 6)
                    
                    Spacer()
                }
                
                HStack {
                    Text(String(points))
                }
                
                Spacer()
                        .frame(height: 30)
                
                
                
                
                if isAdmin {
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
            .frame(minWidth: 0, maxWidth:.infinity)
            
            .overlay(Rectangle().stroke(Color.green, lineWidth: 2))
            .padding(.horizontal)
        }
        .padding()
    }
    
    func add_points(points1: Int) {
        guard let changingPointsInt = Int(changingPoints) else { return }
        print(changingPoints)
        
        let pointsRef = db.collection("points").document(grade)

        // Set the "capital" field of the city 'DC'
        pointsRef.updateData([
            "points": (points + changingPointsInt)
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                
            } else {
                print("Document successfully updated")
                getPointsForGrade()
                changingPoints = ""
            }
        }
    }

    func sub_points(points1: Int) {
        guard let changingPointsInt = Int(changingPoints) else { return }
        
        let pointsRef = db.collection("points").document(grade)

        // Set the "capital" field of the city 'DC'
        pointsRef.updateData([
            "points": (points - changingPointsInt)
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                
            } else {
                print("Document successfully updated")
                getPointsForGrade()
                changingPoints = ""
            }
        }
        
    }
    
    func getPointsForGrade() {
        let docRef = db.collection("points").document(grade)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                if let firebasePoints = document.get("points") as? Int {
                    points = firebasePoints
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}

