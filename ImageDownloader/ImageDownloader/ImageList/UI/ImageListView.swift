//
//  ContentView.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//

import SwiftUI

/// Displays an initial state, a list of images or an error
struct ImageListView: View {
  private let viewState: ImageListViewState
  
  init(viewState: ImageListViewState) {
    self.viewState = viewState
  }
  
  var body: some View {
    NavigationStack {
      content
    }
  }
  
  @ViewBuilder private var content: some View {
    switch viewState {
      case .initial:
        initialState
      case .loading:
        ProgressView()
      case .success(let results):
        if results.isEmpty {
          emptyState
        } else {
          imageList(for: results)
        }
      case .error(let imageSearchError):
        errorState(for: imageSearchError)
    }
  }
  
  /// Initial state
  private var initialState: some View {
    VStack {
      Image(systemName: "magnifyingglass")
        .resizable()
        .frame(width: 80, height: 80)
      Text("Please enter a search term for images")
    }
  }
  
  /// Displays the search results
  private func imageList(for data: [ImageData]) -> some View {
    ScrollView {
      LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 300, maximum: 300)),
                 GridItem(.adaptive(minimum: 300, maximum: 300))]
      ) {
        ForEach(data, id: \.id) { imageData in
          NavigationLink(destination: ImageDetailView(imageData: imageData)) {
            ImageItemView(imageData: imageData)
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
    }
  }
  
  /// Displays the error state
  private func errorState(for error: ImageSearchError) -> some View {
    VStack {
      Text(error.title)
      Text(error.description)
        .font(.caption)
    }
  }
  
  private var emptyState: some View {
    VStack {
      Text("Sorry we weren't able to find anything for that search")
      Text("Please try again later")
        .font(.caption)
    }
  }
}
