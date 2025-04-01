//
//  PostGridsView.swift
//  Zeus
//
//  Created by Renchi Liu on 3/29/25.
//

import SwiftUI

//TODO: Improving ProgressView

struct GridStyle {
    static let columns: Int = 3
    static let spacing: CGFloat = 16
}

struct PostGridsView: View {
    @EnvironmentObject var viewModel: PostsViewModel
    @Binding var path: NavigationPath
    @State private var hasAppeared = false
    private let defaultTitle = "Posts"
    
    private var gridWidth: CGFloat {
        let totalSpacing = GridStyle.spacing * CGFloat(GridStyle.columns + 1)
        return (UIScreen.main.bounds.width - totalSpacing) / CGFloat(GridStyle.columns)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: GridStyle.spacing) {
                postGridRows
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
        .navigationTitle(viewModel.currentUserName ?? defaultTitle)
        .onAppear {
            if !hasAppeared {
                hasAppeared = true
                viewModel.resetAndReload()
            }
        }
    }
    
    private var postGridRows: some View {
        ForEach(viewModel.posts.chunked(into: GridStyle.columns), id: \.self) { row in
            GridRowView(
                row: row,
                gridWidth: gridWidth,
                spacing: GridStyle.spacing,
                onAppear: {
                    if let last = row.last {
                        viewModel.loadMoreIfNeeded(currentPost: last)
                    }
                },
                onSelect: { selected in
                    if let index = viewModel.posts.firstIndex(of: selected) {
                        path.append(index)
                    }
                }
            )
        }
    }
}
