//
//  DashboardViewModel.swift
//  20230814-ChetanBhalara-NYCSchool
//
//  Created by Chetan Bhalara on 8/15/23.
//

import Foundation
import SwiftUI
import Combine

class DashboardViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var schoolResponse: [SchoolData]?
    @Published var schoolSATResponse: [SchoolSATData]?
    
    private var cancellables = Set<AnyCancellable>()
    private var cancellablesSAT = Set<AnyCancellable>()
    
    // API Call for get Schools
    func getSchool(baseURL: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        await NetworkManager.shared.makeNetworkCall(endpoint: .get, httpMethod: .GET, type: [SchoolData].self, baseURL: baseURL).sink { completion in
            self.isLoading = false
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
            case .finished:
                print("Finished")
            }
        } receiveValue: { [weak self] data  in
            
            self?.isLoading = false
            self?.schoolResponse = data
            
        }
        .store(in: &cancellables)
    }
    
    /// This method manage API call based on certain conditions as below
    
    func getSchoolList() async {
        await getSchool(baseURL: Constants.baseSchoolListURL)
    }
    
    func getSchoolSATData(dbn: String) async {
        let baseURL: String = Constants.baseSchoolSATURL + dbn
        await getSchoolSAT(baseURL: baseURL)
    }
    
    // API Call for get School SAT
    func getSchoolSAT(baseURL: String) async {
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        await NetworkManager.shared.makeNetworkCall(endpoint: .get, httpMethod: .GET, type: [SchoolSATData].self, baseURL: baseURL).sink { completion in
            self.isLoading = false
            switch completion {
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
            case .finished:
                print("Finished")
            }
        } receiveValue: { [weak self] data  in
            
            self?.isLoading = false
            self?.schoolSATResponse = data
            
        }
        .store(in: &cancellablesSAT)
    }
}
