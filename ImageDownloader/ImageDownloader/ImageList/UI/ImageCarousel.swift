//
//  ImageCarousel.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/27/25.
//

import SwiftUI
import AVKit

/// Displays a list of images and/or videos.
struct ImageCarousel: View {
  private let images: [Images]
  private let players: [URL: AVPlayer]
  @State private var playing: [URL: Bool] = [:]
  
  init(images: [Images]?) {
    self.images = images ?? []
    self.players = Dictionary(uniqueKeysWithValues: (images ?? []).compactMap {
      // Only create AVPlayers for videos.
      guard $0.isVideoContent, let url = URL(string: $0.link) else {
        return nil
      }
      
      return (url, AVPlayer(url: url))
    })
  }
  
  var body: some View {
    List {
      ForEach(images) { image in
        if let url = URL(string: image.link) {
          VStack {
            contentForImage(url: url, isVideoContent: image.isVideoContent)
            
            if let description = image.description {
              Text(description)
                .font(.caption)
            }
          }
          .listRowSeparator(.hidden)
          .listRowBackground(Color.clear)
        }
      }
    }
  }
  
  /// Displays the view for either image or playable content.
  @ViewBuilder private func contentForImage(url: URL, isVideoContent: Bool) -> some View {
    if isVideoContent {
      VStack {
        let player = players[url] ?? AVPlayer(url: url)
        VideoPlayer(player: player)
          .frame(minHeight: 400)
        
        Button {
          let isPlaying = playing[url] ?? false
          isPlaying ? player.pause() : player.play()
          playing[url] = !isPlaying
          player.seek(to: .zero)
        } label: {
          Image(systemName: (playing[url] ?? false) ? "stop" : "play")
            .padding()
        }
      }
    } else {
      AsyncImage(url: url) { image in
        image
          .resizable()
          .scaledToFit()
      } placeholder: { ProgressView() }
    }
  }
}
