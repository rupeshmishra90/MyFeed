//
//  FeedLoader.swift
//  MyFeed
//
//  Created by Rupesh Mishra on 07/05/24.
//

import Foundation

enum LoadFeedResult{
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult)->Void)
}
