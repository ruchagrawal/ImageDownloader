//
//  ImageListContainer.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/27/25.
//

import SwiftUI

/// Container for searching for images and showing results.
struct ImageListContainer: View {
  @StateObject private var viewModel: ImageListViewModel
  @State private var searchQuery: String = ""
  
  init(viewModel: ImageListViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    ImageListView(viewState: viewModel.imageListViewState)
      .searchable(text: $searchQuery)
      .onSubmit(of: .search, getImagesForSearchString)
  }
  
  private func getImagesForSearchString() {
    Task.detached {
      await viewModel.getImagesFor(queryString: searchQuery)
    }
  }
}
