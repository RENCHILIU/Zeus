//
//  WelcomeView.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

import SwiftUI

//TODO: add textfield input focus
//TODO: add no-search handle
struct WelcomeView: View {
    @State private var username: String = ""
    @State private var path = NavigationPath()
    @State private var isButtonPressed = false
    @State private var isFeelingLuckyPressed = false
    
    @StateObject private var viewModel = PostsViewModel()
    @StateObject private var welcomeVM = WelcomeViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    Text("Welcome to Zeus")
                        .font(.largeTitle)
                        .bold()
                    
                    inputSection
                    actionButtons
                    recentUsersGrid
                }
                .padding()
            }
            .navigationDestination(for: String.self) { val in
                if val == "toGrids" {
                    PostGridsView(path: $path)
                }
            }
            .navigationDestination(for: Int.self) { index in
                PostDetailView(selectedIndex: index)
            }
        }
        .environmentObject(viewModel)
    }
    
    private var inputSection: some View {
        HStack {
            TextField("Enter username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            Toggle("S2", isOn: Binding<Bool>(
                get: { welcomeVM.selectedService == .S2 },
                set: { newValue in
                    welcomeVM.selectedService = newValue ? .S2 : .S1
                }
            ))
            .toggleStyle(SwitchToggleStyle(tint: .blue))


        }
        .padding(.horizontal)
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            GradientActionButton(
                title: "Search 🔍",
                gradient: [Color.blue, Color.purple],
                isDisabled: username.trimmingCharacters(in: .whitespaces).isEmpty,
                action: {
                    let result = welcomeVM.setUserAndResolve(username: username)
                    if result.success, let baseURL = result.baseURL {
                        viewModel.baseURL = baseURL
                        viewModel.currentUserName = welcomeVM.resolvedName
                        path.append("toGrids")
                    }
                },
                isPressed: $isButtonPressed
            )
            
            GradientActionButton(
                title: "I feel lucky 🎲",
                gradient: [Color.orange, Color.pink],
                isDisabled: false,
                action: {
                    if let profile = welcomeVM.fetchLuckyProfile(superLucky: false) {
                        viewModel.baseURL = profile.baseURL
                        viewModel.currentUserName = profile.name
                        path.append("toGrids")
                    }
                },
                isPressed: $isFeelingLuckyPressed
            )
            
            GradientActionButton(
                title: "I feel super lucky 🎯",
                gradient: [Color.green, Color.yellow],
                isDisabled: false,
                action: {
                    if let profile = welcomeVM.fetchLuckyProfile(superLucky: true) {
                        viewModel.baseURL = profile.baseURL
                        viewModel.currentUserName = profile.name
                        path.append("toGrids")
                    }
                },
                isPressed: $isFeelingLuckyPressed
            )
        }
        .padding(.horizontal)
    }

    
    private var recentUsersGrid: some View {
        Group {
            if !welcomeVM.recentUsers.isEmpty {
                Text("Recent:")
                    .font(.headline)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                    ForEach(welcomeVM.recentUsers, id: \.self) { name in
                        Button {
                            username = name
                            let result = welcomeVM.setUserAndResolve(username: name)
                            if result.success, let baseURL = result.baseURL {
                                viewModel.baseURL = baseURL
                                viewModel.currentUserName = welcomeVM.resolvedName
                                path.append("toGrids")
                            }
                        } label: {
                            Text(name)
                                .font(.subheadline)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                )
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func performFeelingLucky(superLucky: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            isFeelingLuckyPressed = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            isFeelingLuckyPressed = false
            guard let profile = welcomeVM.fetchLuckyProfile(superLucky: superLucky) else { return }
            viewModel.baseURL = profile.baseURL
            viewModel.currentUserName = profile.name
            path.append("toGrids")
        }
    }
}
