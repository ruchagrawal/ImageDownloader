//
//  ImageRowView.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//

import SwiftUI

/// Individual item to display for the search results.
struct ImageItemView: View {
  private let imageData: ImageData
  
  private let imageURL: URL?
  private let placeholder = Image(systemName: "photo")
  private let videoPlaceholder = Image(systemName: "play.rectangle.fill")
  
  init(imageData: ImageData) {
    self.imageData = imageData
    self.imageURL = URL(string: imageData.firstContentLink ?? "")
  }
  
  var body: some View {
    VStack {
      // If the content is a video, show a system image.
      if imageData.isVideoContent {
        videoPlaceholder
          .resizable()
          .scaledToFit()
      } else {
        // Otherwise use async image to show the image.
        AsyncImage(url: imageURL) { image in
          image
            .resizable()
            .scaledToFit()
            .overlay(alignment: .topTrailing, content: {
              if let count = imageData.images?.count, count > 1 {
                Text("1/\(count)")
                  .font(.caption)
                  .fontWeight(.bold)
                  .foregroundColor(.white)
                  .padding(4)
              }
            })
        } placeholder: {
          placeholder
            .resizable()
            .scaledToFit()
        }
      }
      Text(imageData.title)
    }
    .padding()
    .background(Color.gray.opacity(0.2))
    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 8, height: 8)))
  }
}
