//
//  CardView.swift
//  SpiritPointsiOSApp
//
//  Created by Rosalie Wessels on 3/19/22.
//

import Foundation
import SwiftUI
import Firebase

struct PointsCard: View {
    @Binding var grade: String
    @State var points = 0
    @Binding var winning_grades : [String]
    @State var db = Firestore.firestore()
    @Binding public var isAdmin : Bool
    @State private var showDialog = false
    @State var adding = true
    @Binding var userEmail : String
    //@State var userEmail = Auth.auth().currentUser?.email ?? "email not found"
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
