//
//  WelcomeViewModel.swift
//  Zeus
//
//  Created by Renchi Liu on 3/31/25.
//

import SwiftUI



class WelcomeViewModel: ObservableObject {
    @Published var resolvedName: String?
    @Published var selectedService: ServiceType = .S1
    @Published var recentUsers: [String] = UserDefaults.standard.stringArray(forKey: "recentUsers") ?? []
    
    func setUserAndResolve(username: String) -> (success: Bool, baseURL: String?) {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return (false, nil) }
        
        guard let result = ProfileDB.shared.searchNameOrIDRawSQL(service: selectedService.rawValue, forName: trimmed) else {
            print("⚠️ No match found for \(trimmed)")
            return (false, nil)
        }
        
        let finalUsernameOrID = selectedService == .S2 ? result.id : result.name
        resolvedName = result.name
        saveToRecentUsers(trimmed)
        
        let baseURL = BASEURL + "/api/v1/\(selectedService.rawValue)/user/\(finalUsernameOrID)"
        return (true, baseURL)
    }
    
    func fetchLuckyProfile(superLucky: Bool) -> (name: String, id: String, baseURL: String)? {
        let luckyProfile = superLucky
        ? ProfileDB.shared.fetchSuperLuckyProfile()
        : ProfileDB.shared.fetchRandomProfile()
        
        guard let profile = luckyProfile else {
            print("❌ No lucky profile found")
            return nil
        }
        
        resolvedName = profile.name
        selectedService = profile.service
        
        let baseURL = BASEURL + "/api/v1/\(profile.service.rawValue)/user/\(profile.id)"
        return (name: profile.name, id: profile.id, baseURL: baseURL)
    }
    
    private func saveToRecentUsers(_ username: String) {
        if !recentUsers.contains(username) {
            recentUsers.insert(username, at: 0)
            if recentUsers.count > 10 {
                recentUsers.removeLast()
            }
            UserDefaults.standard.set(recentUsers, forKey: "recentUsers")
        }
    }
}
