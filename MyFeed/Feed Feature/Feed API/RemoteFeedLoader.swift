//
//  RemoteFeedLoader.swift
//  MyFeed
//
//  Created by Rupesh Kumar on 11/05/24.
//

import Foundation
protocol HTTPClient{
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
}
public final class RemoteFeedLoader{
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error{
        case connectivity
        case invalidData
    }
    
    init(url: URL, client: HTTPClient)
    {
        self.client = client
        self.url = url
    }
    func load(completion: @escaping (Error) -> Void){
        client.get(from: url){ error, response in
            if response != nil{
                completion(.invalidData)
            }else{
                completion(.connectivity)
            }
            
        }
//        client.get(from: url)
    }
}
