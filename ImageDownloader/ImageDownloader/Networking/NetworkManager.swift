//
//  NetworkManager.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//
import Foundation

/// Returns cached data if applicable, or downloads data from the network.
public class NetworkManager {
  private init() {}
  public static let shared = NetworkManager()
  
  /// Returns the data for the URL
  ///
  /// - Parameters:
  ///  - url: The url to get the data for
  ///  - canReturnCacnedData: If we need to get fresh data, this should be set to false
  ///
  ///  - Returns: The data for the URL if successful, throws error otherwise.
  public func downloadData(
    for urlRequest: URLRequest,
    canReturnCachedData: Bool = false
  ) async throws -> Data {
    if canReturnCachedData, let cachedData = URLCache.shared.cachedResponse(for: urlRequest)?.data {
      return cachedData
    }
    
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    let cachedResponse = CachedURLResponse(response: response, data: data)
    URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    
    return data
  }
}
