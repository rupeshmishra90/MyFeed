//
//  URLSessionHTTPClientTests.swift
//  MyFeedTests
//
//  Created by Rupesh Kumar on 06/06/24.
//

import XCTest
@testable import MyFeed

class URLSessionHTTPClient{
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    func get(from url: URL){
        session.dataTask(with: url) { _, _, _ in
            
        }
    }
}


final class URLSessionHTTPClientTests: XCTestCase {
func test_getFromURL_createsDataTakWithURL()
    {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)
        XCTAssertEqual(session.receivedURLs, [url])
    }

    
    //MARK: - Helpers
    private class URLSessionSpy: URLSession{
        var receivedURLs = [URL]()
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask{
        
    }
}
