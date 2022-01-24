//
//  HistoryView.swift
//  SpiritPointsiOSApp
//
//  Created by Tech Club on 4/27/21.
//

import SwiftUI
import Firebase

struct HistoryView: View {
    @State var historyList = [historyItem(stringDate: "test", reason: "test", user: "test", grade: 0, points: 0)]
    @State var db = Firestore.firestore()
    
    var body: some View {
        ScrollView{
            VStack {
                Text("History")
                        .foregroundColor(.green)
                        .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black).padding()
                
                if historyList[0].stringDate != "test" {
                    ForEach(historyList) { result in
                        
                        Text("Date: \(result.stringDate), Reason: \(result.reason), User: \(result.user), Grade: \(result.grade), Points: \(result.points)").font(.headline)
                        
                        Spacer()
                                .frame(height: 20)
                    }
                    

                }
        }
            .padding(.horizontal, 20)
        }
        .onAppear(perform: {
            getHistory()
        })
        
    }
    
    func getHistory() {
        db.collection("history")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if let stringDate = document.get("stringDate") as? String {
                            if let reason = document.get("reason") as? String {
                                if let user = document.get("user") as? String {
                                    if let grade = document.get("grade") as? Int{
                                        if let points = document.get("points") as? Int {
                                            let newHistoryItem = historyItem(stringDate: stringDate, reason: reason, user: user, grade: grade, points: points)
                                            
                                            historyList.append(newHistoryItem)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if historyList.count >= 1 {
                        historyList.remove(at: 0)
                    }
                }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}

struct historyItem: Identifiable {
    var id = UUID()
    var stringDate : String
    var reason : String
    var user : String
    var grade : Int
    var points : Int
}
