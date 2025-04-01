//
//  PostsViewModel.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

import Foundation

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var currentUserName: String?
    @Published var isLoading: Bool = false
    
    var baseURL: String = ""
    
    func resetAndReload() {
        posts.removeAll()
        loadMore()
    }
    
    func loadMoreIfNeeded(currentPost: Post) {
        guard let last = posts.last else { return }
        if currentPost.id == last.id {
            loadMore(offset: posts.count)
        }
    }
    
    private func loadMore(offset: Int = 0) {
        guard !baseURL.isEmpty else {
            print("⚠️ baseURL is empty")
            return
        }
        
        isLoading = true
        NetworkService().fetchPosts(baseURL: baseURL, offset: offset) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let newPosts):
                    self?.posts.append(contentsOf: newPosts)
                case .failure(let error):
                    print("❌ Failed to fetch posts: \(error)")
                }
            }
        }
    }
}
