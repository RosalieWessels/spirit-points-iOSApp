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
    
    @State var winning_grades = ["7th Grade", "Freshman"]
    @State var order = ["7th Grade", "8th Grade", "Freshman", "Sophomores", "Juniors", "Seniors"]
    @State var sortedWay = "grades"
    @State var refreshBarGraph = false

    @State var db = Firestore.firestore()
    
    @State var newUpcomingEvent = ""
    @State var VStacksizing : CGFloat = CGFloat(25)
    
    @AppStorage("log_Status") var status = DefaultStatus.status
    @AppStorage("log_IsAdmin") var isAdmin = false
    @State var user = Auth.auth().currentUser
    @StateObject var model = ModelData()
    
    @State var upcomingEventsList = ["fake event"]
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(spacing: 0) {
                    Spacer()
                    
                    Button(action: {
                        order = ["7th Grade", "8th Grade", "Freshman", "Sophomores", "Juniors", "Seniors"]
                        sortedWay = "grades"
                    }) {
                        Text("Grades")
                            .foregroundColor(.white)
                            .font(.system(.body, design: .rounded))
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color.green)
                            .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                    }
                    
                    Divider()
                        .frame(width: 1)
                    
                    
                    Button(action: {
                        sortGrades()
                        sortedWay = "points"
                    }) {
                        Text("Points")
                            .foregroundColor(.white)
                            .font(.system(.body, design: .rounded))
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color.green)
                            .cornerRadius(20, corners: [.topRight, .bottomRight])
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
                
                
                VStack {
                    VStack (spacing: CGFloat(VStacksizing)){
                        
                        VStack {
                            Text("Spirits Points App")
                            .foregroundColor(.green)
                            .font(.system(.largeTitle, design: .rounded))
                                .fontWeight(.black).padding()
                            
                            if sizeClass == .compact {
                                Image("panthers").resizable().aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: UIScreen.main.bounds.width - 200)
                            } else {
                                Image("panthers").resizable().aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: UIScreen.main.bounds.width / 4)
                            }
                        }
                        
                        
                        //Cards
                        Text("Junior High:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                        
                        if sizeClass == .compact { //if phone screen size
                            if seventhGradePoints != -1 {
                                PointsCard(grade: $order[0], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat(UIScreen.main.bounds.width) - 60)
                                    .padding(.bottom, VStacksizing / 2)
                            }
                            
                            if eighthGradePoints != -1 {
                                PointsCard(grade: $order[1], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat(UIScreen.main.bounds.width) - 60)
                            }
                        }
                        else { //if ipad screen size
                            HStack {
                                Spacer()
                                
                                if seventhGradePoints != -1 {
                                    PointsCard(grade: $order[0], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat((UIScreen.main.bounds.width / 4) - 40))
                                }
                                
                                Spacer()
                                
                                if eighthGradePoints != -1 {
                                    PointsCard(grade: $order[1], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat((UIScreen.main.bounds.width / 4) - 40))
                                }
                                
                                Spacer()
                                
                                Spacer()
                                    .frame(width: UIScreen.main.bounds.width / 2)
                            }
                        }
                        
                        
                        Text("High School:").font(.system(.title2,design: .rounded)).fontWeight(.bold).padding()
                        
                        if sizeClass == .compact { //if phone screen size
                            if ninthGradePoints != -1 {
                                PointsCard(grade: $order[2], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat(UIScreen.main.bounds.width - 60))
                                    .padding(.bottom, VStacksizing / 2)
                            }
                            
                            if tenthGradePoints != -1 {
                                PointsCard(grade: $order[3], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat(UIScreen.main.bounds.width - 60))
                                    .padding(.bottom, VStacksizing / 2)
                            }
                            
                            if eleventhGradePoints != -1 {
                                PointsCard(grade: $order[4], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat(UIScreen.main.bounds.width - 60))
                                    .padding(.bottom, VStacksizing / 2)
                            }
                            
                            if twelfthGradePoints != -1 {
                                PointsCard(grade: $order[5], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat(UIScreen.main.bounds.width - 60))
                            }
                        }
                        else { //if ipad screen size
                            HStack {
                                Spacer()
                                
                                if ninthGradePoints != -1 {
                                    PointsCard(grade: $order[2], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat((UIScreen.main.bounds.width / 4) - 40))
                                }
                                
                                Spacer()
                                
                                if tenthGradePoints != -1 {
                                    PointsCard(grade: $order[3], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat((UIScreen.main.bounds.width / 4) - 40))
                                }
                                
                                Spacer()
                                
                                if eleventhGradePoints != -1 {
                                    PointsCard(grade: $order[4], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat((UIScreen.main.bounds.width / 4) - 40))
                                }
                                
                                Spacer()
                                
                                if twelfthGradePoints != -1 {
                                    PointsCard(grade: $order[5], winning_grades: $winning_grades, isAdmin: $isAdmin, width: CGFloat((UIScreen.main.bounds.width / 4) - 40))
                                }
                                
                                Spacer()
                            }
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
                                }
                                .background(Color.gray)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .padding(.horizontal, CGFloat(VStacksizing))
                                .padding(.vertical)
                                
                            }
                    
                            
                            if isAdmin {
                                HStack (spacing: 20){
                                    TextField("new upcoming event", text: $newUpcomingEvent)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    
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
                                }
                                .padding([.horizontal, .bottom], CGFloat(VStacksizing))
                            }
                        
                        
                        }
                    }
                    }
                }
                //end of vstack here
                 
                VStack (spacing: CGFloat(VStacksizing / 4)) {
                    
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
                        .padding(.top, VStacksizing / 4)
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
                    
                    Text("@Pinewood 2022 Tech Club").padding(.top, CGFloat(VStacksizing / 2))
                    
                }
                
                .navigationBarTitle("")
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
            checkState()
            
            if sizeClass == .compact {
                VStacksizing = CGFloat(25)
            } else {
                VStacksizing = CGFloat(50)
            }
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
            winning_grades[1] = "Freshman"
            
        }
        else if tenthGradePoints >= ninthGradePoints && tenthGradePoints >= eleventhGradePoints && tenthGradePoints >= twelfthGradePoints{
            winning_grades[1] = "Sophomores"
        }
        else if eleventhGradePoints >= ninthGradePoints && eleventhGradePoints >= tenthGradePoints && eleventhGradePoints >= twelfthGradePoints {
            winning_grades[1] = "Juniors"
        }
        else {
            winning_grades[1] = "Seniors"
        }
    }
    
    func findWinnerJH() {
        if seventhGradePoints >= eighthGradePoints{
            winning_grades[0] = "7th Grade"
        }
        else {
            winning_grades[0] = "8th Grade"
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
                if sortedWay == "points" {
                    sortGrades()
                }
                MyVariables.reRunPoints.toggle()
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
                if sortedWay == "points" {
                    sortGrades()
                }
                MyVariables.reRunPoints.toggle()
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
                if sortedWay == "points" {
                    sortGrades()
                }
                MyVariables.reRunPoints.toggle()
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
                if sortedWay == "points" {
                    sortGrades()
                }
                MyVariables.reRunPoints.toggle()
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
                if sortedWay == "points" {
                    sortGrades()
                }
                MyVariables.reRunPoints.toggle()
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
                if sortedWay == "points" {
                    sortGrades()
                }
                MyVariables.reRunPoints.toggle()
            }
        }
    }
    
    func sortGrades() {
        order = []
        let dictionaryJH = ["7th Grade" : seventhGradePoints, "8th Grade" : eighthGradePoints]
        let sortedJH = Array(dictionaryJH.keys).sorted(by: { dictionaryJH[$0]! > dictionaryJH[$1]! })
        for grade in sortedJH {
            order.append(grade)
        }
        
        let dictionaryHS = ["Freshman" : ninthGradePoints, "Sophomores" : tenthGradePoints, "Juniors" : eleventhGradePoints, "Seniors" : twelfthGradePoints]
        let sortedHS = Array(dictionaryHS.keys).sorted(by: { dictionaryHS[$0]! > dictionaryHS[$1]! })
        for grade in sortedHS {
            order.append(grade)
        }
        
        print("SORTED", order)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PointsCard: View {
    @Binding var grade: String
    @State var points = 0
    @Binding var winning_grades : [String]
    @State var db = Firestore.firestore()
    @Binding public var isAdmin : Bool
    @State private var showDialog = false
    @State var adding = true
    @State var userEmail = Auth.auth().currentUser?.email ?? "email not found"
    @State var width : CGFloat
    
    @State var changingPoints: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                    .frame(height: 5)
                    .alert(isPresented: $showDialog,
                           TextAlert(title: "Add a reason",
                                     message: "This is a requirement",
                                     keyboardType: .default) { result in
                        if adding == true {
                            add_points(points1: points, reason: result ?? "no reason given")
                        }
                        else if adding == false {
                            sub_points(points1: points, reason: result ?? "no reason given")
                        }
                   })
                
                Rectangle()
                    .fill(Color.green)
                
                HStack {
                    if winning_grades.contains(grade) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                    }
        
                    Text(grade)
                        .font(.body).fontWeight(.heavy)
                        .foregroundColor(Color.white)
                        .font(.system(.title2,design: .rounded))
                        
                        
                }            }
            .frame(height: 60)
            
            Spacer()
            
            VStack (alignment: .leading, spacing: 20) {
                
                Text("Number of Points:")
                    .bold()
                
                Text(String(points))
                
                if isAdmin == true {
                    HStack{
                    
                        TextField("# of points added", text: $changingPoints)
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
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(width: width, height: 225)
        .border(Color.green, width: 2)
        .onAppear(perform: getPointsForGrade)
        .onChange(of: grade) { newValue in
            getPointsForGrade()
        }
        .onChange(of: MyVariables.reRunPoints) { newValue in
            getPointsForGrade()
        }
        
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

//EXTENSIONS
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct MyVariables {
    static var reRunPoints = false
}
