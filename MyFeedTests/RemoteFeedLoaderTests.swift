//
//  RemoteFeedLoaderTests.swift
//  MyFeedTests
//
//  Created by Rupesh Mishra on 07/05/24.
//

import XCTest

class RemoteFeedLoader{
    func load(){
        HTTPClient.shared.requestedURL = URL(string: "https://a-url.com")
    }
}
class HTTPClient{
    static let shared = HTTPClient()
    private init() {
    }
    var requestedURL: URL?
}
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL()
    {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    func test_init_loadDataFromURL()
    {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
