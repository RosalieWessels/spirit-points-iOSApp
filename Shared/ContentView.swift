//
//  ContentView.swift
//  Shared
//
//  Created by Tech Club on 11/23/20.
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
    
    @State var iswinner_7th = false
    @State var iswinner_8th = false
    @State var iswinner_9th = false
    @State var iswinner_10th = false
    @State var iswinner_11th = false
    @State var iswinner_12th = false
    
    @State var refreshBarGraph = false

    @State var db = Firestore.firestore()
    
    @State var newUpcomingEvent = ""
    
    @AppStorage("log_Status") var status = DefaultStatus.status
    @AppStorage("log_IsAdmin") var isAdmin = false
    @State var user = Auth.auth().currentUser
    @StateObject var model = ModelData()
    
    @State var upcomingEventsList = ["fake event"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack (spacing: 25){
                        VStack {
                            Text("Spirits Points App")
                            .foregroundColor(.green)
                            .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.black).padding()
                            
                            Image("panthers").resizable().aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width - 200)
                        }
                        
                        
                        //Cards
                        Text("Junior High:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                    
                        if seventhGradePoints != -1 {
                            PointsCard(grade: "7th Grade", points: $seventhGradePoints, is_winner: $iswinner_7th, isAdmin: $isAdmin)
                        }
                        
                        if eighthGradePoints != -1 {
                            PointsCard(grade: "8th Grade", points: $eighthGradePoints, is_winner: $iswinner_8th, isAdmin: $isAdmin)
                        }
                        
                        Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                
                        if ninthGradePoints != -1 {
                            PointsCard(grade: "Freshman", points: $ninthGradePoints, is_winner: $iswinner_9th, isAdmin: $isAdmin)
                        }
                        
                        if tenthGradePoints != -1 {
                            PointsCard(grade: "Sophomores", points: $tenthGradePoints, is_winner: $iswinner_10th, isAdmin: $isAdmin)
                        }
                        
                        if eleventhGradePoints != -1 {
                            PointsCard(grade: "Juniors", points: $eleventhGradePoints, is_winner: $iswinner_11th, isAdmin: $isAdmin)
                        }
                        
                        if twelfthGradePoints != -1 {
                            PointsCard(grade: "Seniors", points: $twelfthGradePoints, is_winner: $iswinner_12th, isAdmin: $isAdmin)
                        }
                        
                    Group{
                    //Add Bar Graph here:
                        let chartStyle = ChartStyle(backgroundColor: Color.black, accentColor: Colors.OrangeStart, secondGradientColor: Color.green, textColor: Color.white, legendTextColor: Color.black, dropShadowColor: Color.white)

                    
                        Spacer()

                        if twelfthGradePoints != -1 && eleventhGradePoints != -1 && tenthGradePoints != -1 && ninthGradePoints != -1 && eighthGradePoints != -1 && seventhGradePoints != -1 && refreshBarGraph == false {
                            BarChartView(data: ChartData(values: [("7th-grade", seventhGradePoints), ("8th-grade", eighthGradePoints), ("9th-grade", ninthGradePoints),
                                ("10th-grade", tenthGradePoints),
                                ("11th-grade", eleventhGradePoints),
                                ("12th-grade", twelfthGradePoints)]), title: "Spirit Points Bar Graph", legend: "Per Grade", style: chartStyle, form: ChartForm.extraLarge)

                        }

                        


                        Spacer()
                    
                    
                    
                        VStack (spacing: 0) {
                        //Add Upcoming Events section here:
                            Text("Upcoming Events - Get Hyped")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .padding()
                            
                            
                            
                            if upcomingEventsList[0] != "fake event" {
                                
                                VStack(spacing: 1) {
                                    ForEach(upcomingEventsList, id: \.self) { event in
                                        Text("\(event)")
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 55)
                                        .background(Color.white)

                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 55)
                                    .background(Color.white)
                                }
                                .background(Color.gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding()
                                
                            }
                    
                            
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
                    
                    if isAdmin != true {
                        Button(action: {
                            model.isLogIn.toggle()
                        }) {
                            Text("Admin")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
                        )
                    }
                    
                    
                    
                    if isAdmin {
                        NavigationLink(destination: HistoryView()) {
                            Text("History")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
                            )
                        
                        NavigationLink(destination: UsersView()) {
                            Text("See Users")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
                            )
                        
                        Button(action: {
                            model.logOut()
                            checkState()
                        }) {
                            Text("Log out")
                                .foregroundColor(.green)
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.green, lineWidth: 2)
                            )
                        
                    }
                    
                    Text("@Pinewood 2022 Tech Club").padding(.top, 20)
                    
                }
                
                .navigationTitle("")
                .navigationBarHidden(true)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $model.isLogIn, content: {
                    LogInView(model: model)
                })
        .onAppear(perform: {
            getPoints()
            pullUpcomingEvents()
            //findWinningGradeHS()
            checkState()
        })
    }
    
    func checkState() {
        print("CHECK STATE")
        if status == true {
            isAdmin = true
            print("LOGGED IN")
            print("IS ADMIN", isAdmin)
        }
        else {
            isAdmin = false
        }
    }
    
    func addUpcomingEvent(){
        db.collection("upcoming events").document(newUpcomingEvent).setData([
            "NameAndDate": newUpcomingEvent
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                upcomingEventsList.insert("fake event", at: 0)
                pullUpcomingEvents()
                newUpcomingEvent = ""
            }
        }
    }
    
    func pullUpcomingEvents(){
//        db.collection("upcoming events")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        if let title = document.get("NameAndDate") as? String{
//                            upcomingEventsList.append(title)
//                        }
//                    }
//                    upcomingEventsList.remove(at:0)
//                }
//        }
        
        db.collection("upcoming events")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                upcomingEventsList = ["fake event"]
                //success
                for document in querySnapshot!.documents {
                    if let title = document.get("NameAndDate") as? String{
                        upcomingEventsList.append(title)
                    }
                }
                upcomingEventsList.remove(at:0)
                print(upcomingEventsList)
            }

    }
    
    //Finding grade with the least amount of points (current winners)
    func findWinnerHS() {
        if ninthGradePoints >= tenthGradePoints && ninthGradePoints >= eleventhGradePoints && ninthGradePoints >= twelfthGradePoints{
            iswinner_9th = true
            iswinner_10th = false
            iswinner_11th = false
            iswinner_12th = false
            
        }
        else if tenthGradePoints >= ninthGradePoints && tenthGradePoints >= eleventhGradePoints && tenthGradePoints >= twelfthGradePoints{
            iswinner_9th = false
            iswinner_10th = true
            iswinner_11th = false
            iswinner_12th = false
        }
        else if eleventhGradePoints >= ninthGradePoints && eleventhGradePoints >= tenthGradePoints && eleventhGradePoints >= twelfthGradePoints {
            iswinner_9th = false
            iswinner_10th = false
            iswinner_11th = true
            iswinner_12th = false
        }
        else {
            iswinner_9th = false
            iswinner_10th = false
            iswinner_11th = false
            iswinner_12th = true
        }
    }
    
    func findWinnerJH() {
        if seventhGradePoints >= eighthGradePoints{
            iswinner_7th = true
            iswinner_8th = false
        }
        else {
            iswinner_7th = false
            iswinner_8th = true
        }
    }
    
    func refreshBarGraphFunction() {
        refreshBarGraph = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            refreshBarGraph = false
        }
    }
    
    
    func getPoints() {
        
        db.collection("points").document("7th Grade")
        .addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            if let points = document.get("points") as? Int {
                print("FOUND THE DATA")
                seventhGradePoints = points
                print(seventhGradePoints)
                findWinnerJH()
                refreshBarGraphFunction()
            }
        }
        
        //8th Grade
        let docRefEightGrade = db.collection("points").document("8th Grade")
        
        docRefEightGrade.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            if let points = document.get("points") as? Int {
                print("FOUND THE DATA")
                eighthGradePoints = points
                print(eighthGradePoints)
                findWinnerJH()
                refreshBarGraphFunction()
            }
        }
        
        // Freshman
        let docRefFreshman = db.collection("points").document("Freshman")
        
        docRefFreshman.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            if let points = document.get("points") as? Int {
                print("FOUND THE DATA")
                ninthGradePoints = points
                print(ninthGradePoints)
                findWinnerHS()
                refreshBarGraphFunction()
            }
        }
        
        // Sophomore
        let docRefSophomore = db.collection("points").document("Sophomores")
        
        docRefSophomore.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            if let points = document.get("points") as? Int {
                print("FOUND THE DATA")
                tenthGradePoints = points
                print(tenthGradePoints)
                findWinnerHS()
                refreshBarGraphFunction()
            }
        }
        
        // Juniors
        let docRefJunior = db.collection("points").document("Juniors")
        
        docRefJunior.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            if let points = document.get("points") as? Int {
                print("FOUND THE DATA")
                eleventhGradePoints = points
                print(eleventhGradePoints)
                findWinnerHS()
                refreshBarGraphFunction()
            }
        }
        
        // Seniors
        let docRefSenior = db.collection("points").document("Seniors")
        
        docRefSenior.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            if let points = document.get("points") as? Int {
                print("FOUND THE DATA")
                twelfthGradePoints = points
                print(twelfthGradePoints)
                findWinnerHS()
                refreshBarGraphFunction()
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
    @Binding var points: Int
    @Binding var is_winner: Bool
    @State var db = Firestore.firestore()
    @Binding public var isAdmin : Bool
    @State private var showDialog = false
    @State var adding = true
    @State var userEmail = Auth.auth().currentUser?.email ?? "email not found"
    
    @State var changingPoints: String = ""
    
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
            .alert(isPresented: $showDialog,
                TextAlert(title: "Please add a reason",
                          message: "This is a requirement",
                          keyboardType: .numberPad) { result in
                if adding == true {
                    add_points (points1: points, reason: result ?? "no reason given")
                }
                else if adding == false {
                    sub_points(points1: points, reason: result ?? "no reason given")
                }
                
            })
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
                
                
                
                
                if isAdmin == true {
                    HStack{
                        
                        TextField("# of points added", text:$changingPoints)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action:{
                            showDialog = true
                            adding = true
                        }) {
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
                    
                        Button(action:{
                            showDialog = true
                            adding = false
                        }){
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
    
    func add_points(points1: Int, reason: String) {
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
        
        //update history in Database
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let dateString = formatter.string(from: now)
        
        db.collection("history").document(dateString).setData([
            "date": now,
            "grade": getGradeNumber(grade: grade),
            "points": changingPointsInt,
            "reason" : reason,
            "stringDate" : dateString,
            "user": userEmail
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func getGradeNumber(grade: String) -> Int {
        if grade == "7th Grade" {
            return 7
        }
        else if grade == "8th Grade" {
            return 8
        }
        else if grade == "Freshman" {
            return 9
        }
        else if grade == "Sophomores" {
            return 10
        }
        else if grade == "Juniors" {
            return 11
        }
        else if grade == "Seniors" {
            return 12
        }
        return 0
    }

    func sub_points(points1: Int, reason: String) {
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
        
        //update history in Database
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let dateString = formatter.string(from: now)
        
        db.collection("history").document(dateString).setData([
            "date": now,
            "grade": getGradeNumber(grade: grade),
            "points": -changingPointsInt,
            "reason" : reason,
            "stringDate" : dateString,
            "user": userEmail
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
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
