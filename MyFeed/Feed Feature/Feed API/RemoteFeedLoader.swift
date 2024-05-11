//
//  RemoteFeedLoader.swift
//  MyFeed
//
//  Created by Rupesh Kumar on 11/05/24.
//

import Foundation
protocol HTTPClient{
    func get(from url: URL)
}
public final class RemoteFeedLoader{
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
    }
    
    init(url: URL, client: HTTPClient)
    {
        self.client = client
        self.url = url
    }
    func load(completion: (Error) -> Void = {_ in }){
        client.get(from: url)
//        client.get(from: url)
    }
}
