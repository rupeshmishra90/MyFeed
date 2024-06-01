//
//  RemoteFeedLoader.swift
//  MyFeed
//
//  Created by Rupesh Kumar on 11/05/24.
//

import Foundation


public final class RemoteFeedLoader: FeedLoader{
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    public typealias Result = LoadFeedResult
//    public enum Result: Equatable{
//        case success([FeedItem])
//        case failure(Error)
//    }
    public init(url: URL, client: HTTPClient)
    {
        self.client = client
        self.url = url
    }
    public func load(completion: @escaping (Result) -> Void){
        client.get(from: url){[weak self] result in
            guard self != nil else{
                return
            }
            switch result
            {
            case let .success(data, response):
                print(response.statusCode)
                print(data)
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
    
   
}
