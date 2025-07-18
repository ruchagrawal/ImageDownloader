//
//  ImageListViewModel.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//

import Combine
import Foundation
import UIKit

/// Possible errors while fetching a list of images
public enum ImageSearchError: Error {
  case malformedRequest
  case dataParsingError
  
  /// Title to show on error screen
  public var title: String {
    switch self {
      case .malformedRequest:
        return String(localized: "There was an issue with the search request")
      case .dataParsingError:
        return String(localized: "There was an issue in getting the results")
    }
  }
  
  /// Description to show on error screen
  public var description: String {
    switch self {
      case .malformedRequest:
        return String(localized: "Please enter another search term or try again later")
      case .dataParsingError:
        return String(localized: "Please try again later")
    }
  }
}

/// The possible view states for image search
public enum ImageListViewState {
  case initial
  case loading
  case success(results: [ImageData])
  case error(ImageSearchError)
}

/// Viewmodel to get the images for search query
public class ImageListViewModel: ObservableObject {
  /// Published view state for given query
  @Published public private(set) var imageListViewState: ImageListViewState = .initial
  
  private let networkManager: NetworkManager = NetworkManager.shared
  private let baseURLString: String = "https://api.imgur.com/3/gallery/search/"
  
  public init() {
    // Initialize the url cache to cache images in async image view
    URLCache.shared.memoryCapacity = 100 * 1024 * 1024 // 100 MB memory space
    URLCache.shared.diskCapacity = 10 * 1024 * 1024 * 1024 // 10GB disk cache space
  }
  
  public func getImagesFor(queryString: String) async {
    do {
      // Update state to loading
      await MainActor.run {
        self.imageListViewState = .loading
      }
      
      // Create URL
      let request = try RequestBuilder.constructURLRequest(
        urlString: baseURLString,
        httpMethod: .get,
        queryParameters: ["q": queryString]
      )
      
      // Download the data
      let data = try await networkManager.downloadData(for: request)
      // Decode it
      let decoder = JSONDecoder()
      let decodedData = try decoder.decode(ImageListResult.self, from: data)
      
      // Update state
      await MainActor.run {
        self.imageListViewState = .success(results: decodedData.data)
      }
    } catch NetworkError.invalidURL {
      await MainActor.run {
        self.imageListViewState = .error(.malformedRequest)
      }
    } catch {
      await MainActor.run {
        self.imageListViewState = .error(.dataParsingError)
      }
    }
  }
}
