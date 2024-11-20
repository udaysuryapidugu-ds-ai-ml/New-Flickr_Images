import XCTest
@testable import The_Flickr_Images

final class MyAppTests: XCTestCase {

    var viewModel: FlickrSearchViewModel!
         
    override func setUp() {
              super.setUp()
             
              
              viewModel = FlickrSearchViewModel()
          }
  
          override func tearDown() {
              viewModel = nil
            
              super.tearDown()
          }
  
          func testPerformSearchSuccessfullyDecodesData() {
              // Given
              let mockJSON = """
              {
                  "items": [
                      {
                          "title": "Sample Image",
                          "link": "https://www.flickr.com/photos/sample/1/",
                          "media": { "m": "https://live.staticflickr.com/12345/sample.jpg" },
                          "date_taken": "2024-11-19T00:00:00-08:00",
                          "description": "Sample description",
                          "published": "2024-11-20T12:00:00Z",
                          "author": "nobody@flickr.com (\\\"Sample Author\\\")",
                          "author_id": "12345",
                          "tags": "sample tag"
                      }
                  ]
              }
              """
            
  
              // When
              viewModel.searchText = "sample"
              viewModel.performSearch()
  
              // Wait for async completion
              let expectation = XCTestExpectation(description: "Search completes")
              DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                  expectation.fulfill()
              }
              wait(for: [expectation], timeout: 2)
  
              // Then
              XCTAssertFalse(viewModel.isLoading)
              XCTAssertEqual(viewModel.items.count, 1)
              XCTAssertEqual(viewModel.items.first?.title, "Sample Image")
              XCTAssertEqual(viewModel.items.first?.author, "nobody@flickr.com (\"Sample Author\")")
          }
  
  }
  
