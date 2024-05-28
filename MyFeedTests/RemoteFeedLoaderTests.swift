//
//  RemoteFeedLoaderTests.swift
//  MyFeedTests
//
//  Created by Rupesh Mishra on 07/05/24.
//

import XCTest
@testable import MyFeed




final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesNotRequestDataFromURL()
    {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    func test_load_requestsDataFromURL()
    {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{_ in }
        XCTAssertEqual(client.requestedURLs, [url])
    }
    func test_loadTwice_requestsDataFromURLTwice()
    {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        sut.load{_ in }
        sut.load{_ in }
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    func test_load_deliverErrorOnClientError()
    {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliverErrorOnNon200ErrorResponse()
    {
        let (sut, client) = makeSUT()
        let samles = [199, 201, 300, 400, 500]
        samles.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            }
        }
        
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJson()
    {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            let invalidJson = Data("Invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        }
        
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyList()
    {
        let (sut, client) = makeSUT()
        expect(sut, toCompleteWith: .success([])) {
            let emptyListJson = makeItemJSON([])
            client.complete(withStatusCode: 200, data: emptyListJson)
        }
    }
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems()
    {
        let (sut, client) = makeSUT()
        let item1 = makeItem(id: UUID(), imageUrl: URL(string: "https://a-url.com")!)
        
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageUrl: URL(string: "https://a-url.com")!)
        
        let items = [item1.model, item2.model]
        expect(sut, toCompleteWith: .success(items)){
            let json = makeItemJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageUrl: URL)-> (model: FeedItem, json: [String: Any]){
        let item = FeedItem(id: id, description: description, location: location, imageUrl: imageUrl)
        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.imageUrl.absoluteString
        ].reduce(into: [String: Any]())
        {(acc, e) in
            if let value = e.value{
                acc[e.key] = value
            }
        }
        print(item)
        return (item, json)
    }
    private func makeItemJSON(_ items: [[String: Any]])-> Data{
        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    //MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!)-> (sut: RemoteFeedLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, file: StaticString = #file, line: UInt = #line, when action: ()-> Void)
    {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load {capturedResults.append($0)}
        action()
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient{
        
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL]{
            return messages.map{ $0.url}
        }
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
        {
            messages.append((url, completion))
        }
        func complete(with error: Error, at index: Int = 0)
        {
            messages[index].completion(.failure(error))
        }
        func complete(withStatusCode code: Int, data: Data,at index: Int = 0)
        {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }
}
