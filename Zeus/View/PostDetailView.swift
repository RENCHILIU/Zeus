//
//  PostDetailView.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//
//

import SwiftUI

struct PostDetailView: View {
    @EnvironmentObject var viewModel: PostsViewModel
    var selectedIndex: Int
    
    @State private var currentIndex: Int = 0
    @State private var selectedImageURL: URL?
    @State private var showFullImage: Bool = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            TabView(selection: $currentIndex) {
                ForEach(Array(viewModel.posts.enumerated()), id: \.element.id) { index, post in
                    SinglePostDetail(
                        post: post,
                        selectedImageURL: $selectedImageURL
                    )
                    .tag(index)
                    .padding()
                }
            }
            .tabViewStyle(.page)
        }
        .navigationTitle(currentPostTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            currentIndex = selectedIndex
        }
        .fullScreenCover(isPresented: $showFullImage) {
            FullScreenImageView(url: $selectedImageURL)
        }
        .onChange(of: selectedImageURL) {
            showFullImage = selectedImageURL == nil ? false : true
        }
    }
    
    private var currentPostTitle: String {
        guard viewModel.posts.indices.contains(currentIndex) else {
            return "Post"
        }
        let title = viewModel.posts[currentIndex].title
        return title.isEmpty ? "Post" : title
    }
}
