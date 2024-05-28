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
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem]
    {
        guard response.statusCode == OK_200 else{
            throw RemoteFeedLoader.Error.invalidData
        }
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map({$0.item})
    }
}
