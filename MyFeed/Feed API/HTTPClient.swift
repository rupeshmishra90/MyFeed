//
//  HTTPClient.swift
//  MyFeed
//
//  Created by Rupesh Kumar on 28/05/24.
//

import Foundation

public enum HTTPClientResult{
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient{
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
