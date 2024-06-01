//
//  FeedLoader.swift
//  MyFeed
//
//  Created by Rupesh Mishra on 07/05/24.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader{
    func load(completion: @escaping (LoadFeedResult)->Void)
}
