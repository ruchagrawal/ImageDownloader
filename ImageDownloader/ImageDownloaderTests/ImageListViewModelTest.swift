//
//  ImageListViewModelTest.swift
//  ImageDownloaderTests
//
//  Created by Ruchi Agrawal on 5/28/25.
//

import Combine
import XCTest
import ImageDownloader

final class ImageListViewModelTest: XCTestCase {
  private var cancellables: Set<AnyCancellable> = Set()
  
  func testInitialState() async {
    let viewModel = ImageListViewModel()
    let expectation = XCTestExpectation(description: "Initial state")
    viewModel.$imageListViewState
      .sink { value in
        if case .initial = value {
          expectation.fulfill()
        } else {
          XCTFail("Initial state is invalid")
        }
      }.store(in: &cancellables)
    
    await fulfillment(of: [expectation])
  }
  
  func testValidURL() async {
    let viewModel = ImageListViewModel()
    let expectation = XCTestExpectation(description: "Valid url")
    
    viewModel.$imageListViewState
      .collect(2)
      .sink { value in
        if case .success = value.last {
          expectation.fulfill()
        } else {
          XCTFail("This should return a value")
        }
      }
      .store(in: &cancellables)
    
    let _ = await viewModel.getImagesFor(queryString: "cats and dogs ext:gif")
    await fulfillment(of: [expectation])
  }
}
