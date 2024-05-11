//
//  RemoteFeedLoaderTests.swift
//  MyFeedTests
//
//  Created by Rupesh Mishra on 07/05/24.
//

import XCTest

class RemoteFeedLoader{
    let client: HTTPClient
    let url: URL
    init(url: URL, client: HTTPClient)
    {
        self.client = client
        self.url = url
    }
    func load(){
        client.get(from: url)
    }
}
protocol HTTPClient{
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient{
    func get(from url: URL)
    {
        requestedURL = url
    }
    var requestedURL: URL?
}
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL()
    {
        let client = HTTPClientSpy()
        let url = URL(string: "https://a-url.com")!
        _ = RemoteFeedLoader(url: url, client: client)
        
        XCTAssertNil(client.requestedURL)
    }
    func test_init_loadDataFromURL()
    {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
    }
}
