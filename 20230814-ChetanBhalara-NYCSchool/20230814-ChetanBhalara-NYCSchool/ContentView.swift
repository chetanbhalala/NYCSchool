//
//  ContentView.swift
//  20230814-ChetanBhalara-NYCSchool
//
//  Created by Chetan Bhalara on 8/15/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var dashboardViewModel = DashboardViewModel()
    @State var selectedSchool: SchoolData? // <- track the selected item
    
    @State private var selection: String?
    
    var body: some View {
        
        NavigationView {
            
            LoadingView(isShowing:dashboardViewModel.isLoading) {
                
                List {
                    if dashboardViewModel.schoolResponse != nil {
                        ForEach(dashboardViewModel.schoolResponse!) { school in
                            UserRowView(school).onTapGesture {
                                self.selectedSchool = school // select the tapped item
                            }
                        }
                    }
                }
                .navigationTitle("NYC Schools")
                .onAppear {
                    Task{
                        await dashboardViewModel.getSchoolList()
                    }
                }
            }
        }
        .sheet(item: $selectedSchool) { school in // show a new sheet if selectedItem is not `nil`
            DashboardDetailView(schoolResponse: school)
        }
    }
}

struct UserRowView: View {
    private let school: SchoolData
    init(_ school: SchoolData) {
        self.school = school
    }
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("\(school.schoolName ?? "No Data")")
                .fontWeight(.bold)
            Text("Address:  \(school.primaryAddressLine1 ?? ""), \(school.city ?? ""), \(school.stateCode ?? ""), \(school.zip ?? "")")
                .fontWeight(.regular)
            Text("Tel: \(school.phoneNumber ?? "No Data")")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
