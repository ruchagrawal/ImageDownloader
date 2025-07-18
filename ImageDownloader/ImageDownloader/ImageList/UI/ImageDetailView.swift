//
//  ImageDetailView.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//

import SwiftUI

/// Detail view when you click on a search result.
struct ImageDetailView: View {
  private let imageData: ImageData
  
  init(imageData: ImageData) {
    self.imageData = imageData
  }
  
  var body: some View {
    VStack {
      Text(imageData.title).padding()
      ImageCarousel(images: imageData.images)
    }
  }
}
