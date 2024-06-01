//
//  FeedItemsMapper.swift
//  MyFeed
//
//  Created by Rupesh Kumar on 28/05/24.
//

import Foundation
final class FeedItemsMapper{
    private struct Root: Decodable{
        let items: [Item]
        var feed: [FeedItem]{
            return items.map({$0.item})
        }
    }

    private struct Item: Decodable{
        let id: UUID
        let description: String?
        let location: String?
        let image: URL
        
        var item: FeedItem{
            return FeedItem(id: id, description: description, location: location, imageUrl: image)
        }
    }
    private static var OK_200: Int{return 200}
    
    internal static func map(_ data: Data, from response: HTTPURLResponse )-> RemoteFeedLoader.Result
    {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else{
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        do{
            return .success(root.feed)
        }
    }
}
