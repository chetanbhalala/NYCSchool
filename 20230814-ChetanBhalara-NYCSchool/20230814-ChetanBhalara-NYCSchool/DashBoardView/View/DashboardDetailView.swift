//
//  DashboardDetailView.swift
//  20230814-ChetanBhalara-NYCSchool
//
//  Created by Chetan Bhalara on 8/15/23.
//

import SwiftUI

struct DashboardDetailView: View {
    var schoolResponse: SchoolData?
    @ObservedObject var dashboardViewModel = DashboardViewModel()
    
    var body: some View {
        
        LoadingView(isShowing:dashboardViewModel.isLoading) {
            
            List {
                if dashboardViewModel.schoolSATResponse != nil {
                    ForEach(dashboardViewModel.schoolSATResponse!) { school in
                        SchoolRowView(school)
                    }
                }
            }
            .onAppear {
                Task{
                    await dashboardViewModel.getSchoolSATData(dbn: schoolResponse?.dbn ?? "")
                }
            }
        }
    }
}

struct SchoolRowView: View {
    private let school: SchoolSATData
    init(_ school: SchoolSATData) {
        self.school = school
    }
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("\(school.schoolName)")
                .fontWeight(.bold)
            Text("No of SAT Test Takers:  \(school.numOfSatTestTakers)")
                .fontWeight(.medium)
            Text("Critical Reading Avg Score: \(school.satCriticalReadingAvgScore )")
                .fontWeight(.medium)
            Text("Math Avg Score: \(school.satMathAvgScore )")
                .fontWeight(.medium)
            Text("Writing Avg Score: \(school.satWritingAvgScore )")
                .fontWeight(.medium)
            //            Text("Address: \(user.address.formatted())")
            //                .italic()
            //                .foregroundColor(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(10)
    }
}
