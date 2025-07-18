//
//  ImageData.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//

import Foundation

/// List of results with title and images.
public struct ImageListResult: Decodable {
  public let data: [ImageData]
}

/// Data with title and a list of images/videos.
public struct ImageData: Identifiable, Decodable {
  public let id: String
  public let title: String
  public let images:[Images]?
  
  /// Link for the first content to show on the search results page.
  public var firstContentLink: String? {
    images?.first?.link
  }
  
  /// Whether the display content is a video.
  public var isVideoContent: Bool {
    images?.first?.isVideoContent ?? false
  }
}

/// Image/Video content for the search results.
public struct Images: Identifiable, Decodable {
  public let id: String
  public let description: String?
  public let link: String
  
  /// Returns if this content is a video.
  public var isVideoContent: Bool {
    link.hasSuffix("mp4")
  }
}
