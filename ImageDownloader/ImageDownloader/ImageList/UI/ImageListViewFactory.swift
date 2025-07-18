//
//  ImageListViewFactory.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/28/25.
//
import SwiftUI

/// Initializes and returns the view.
public class ImageListViewFactory {
  public func makeImageListView() -> some View {
    let viewModel = ImageListViewModel()
    return ImageListContainer(viewModel: viewModel)
  }
}
