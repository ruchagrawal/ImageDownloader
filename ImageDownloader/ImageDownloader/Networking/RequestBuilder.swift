//
//  RequestBuilder.swift
//  ImageDownloader
//
//  Created by Ruchi Agrawal on 5/26/25.
//

import Foundation

/// Errors while creating a network request
public enum NetworkError: Error {
    case invalidURL
}

/// Possible HTTP methods
public enum HTTPRequestMethod: String {
  case get = "GET"
  case put = "PUT"
  case post = "POST"
  case delete = "DELETE"
}

/// Creates a URL request from given data.
public enum RequestBuilder {
  private static let authHeader = ["Authorization": "Client-ID b067d5cb828ec5a"]

  /// Utility method to create a URL request with the given params
  ///
  /// - Parameters:
  ///  - urlString: The string to get the data from.
  ///  - headers: The request headers, defaults to nil.
  ///  - queryParams: The query parameters to send with the request, defaults to nil.
  ///  - bodyData: Optional data for the request body.
  ///  - canReturnCachedData: If the request can return cached data or if it needs to load from network.
  ///
  /// - Returns: The request with the headers, params, query data and body data if successful, throws an error otherwise.
  public static func constructURLRequest(
    urlString: String,
    httpMethod: HTTPRequestMethod,
    shouldAddAuthHeaders: Bool = true,
    headers: [String: String]? = nil,
    queryParameters: [String: String]? = nil,
    bodyData: Data? = nil,
    canReturnCachedData: Bool = false
  ) throws -> URLRequest {
    var components = URLComponents(string: urlString)
    
    // Add query parameters to url
    if let queryParameters {
      components?.queryItems = queryParameters.map { return URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    // Set cache policy
    let cachePolicy: URLRequest.CachePolicy = canReturnCachedData ? .returnCacheDataElseLoad : .useProtocolCachePolicy
    
    guard let url = components?.url else {
      throw NetworkError.invalidURL
    }
    
    var request = URLRequest(url: url, cachePolicy: cachePolicy)
    request.httpMethod = httpMethod.rawValue
    
    // Set headers for request
    if let headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    if shouldAddAuthHeaders {
      for (key,value) in authHeader {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }
    
    // Set body data
    if let bodyData, (httpMethod == .post || httpMethod == .put) {
      request.httpBody = bodyData
    }
    
    return request
  }
}
