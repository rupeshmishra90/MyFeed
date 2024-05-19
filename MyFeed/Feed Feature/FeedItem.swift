//
//  FeedItem.swift
//  MyFeed
//
//  Created by Rupesh Mishra on 07/05/24.
//

import Foundation

public struct FeedItem: Equatable{
    let id: UUID
    let description: String?
    let location: String?
    let imageUrl: URL
}
