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
            
        }.resume()
    }
}


final class URLSessionHTTPClientTests: XCTestCase {
//func test_getFromURL_createsDataTaskWithURL()
//    {
//        let url = URL(string: "https://any-url.com")!
//        let session = URLSessionSpy()
//        let sut = URLSessionHTTPClient(session: session)
//        sut.get(from: url)
//        XCTAssertEqual(session.receivedURLs, [url])
//    }
    func test_getFromURL_resumesDataTaskWithURL()
        {
            let url = URL(string: "https://any-url.com")!
            let session = URLSessionSpy()
            let task = FakeURLSessionDataTaskSpy()
            session.stub(url:  url, task: task)
            let sut = URLSessionHTTPClient(session: session)
            sut.get(from: url)
            XCTAssertEqual(task.resumeCallCount, 1)
        }

    
    //MARK: - Helpers
    private class URLSessionSpy: URLSession{
        private var stub = [URL: URLSessionDataTask]()
        
        func stub(url: URL, task: URLSessionDataTask)
        {
            stub[url] = task
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
            return stub[url] ?? FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask{
        override func resume() {
        }
    }
    private class FakeURLSessionDataTaskSpy: URLSessionDataTask{
        var resumeCallCount = 0
        override func resume() {
            resumeCallCount += 1
        }
    }
}
