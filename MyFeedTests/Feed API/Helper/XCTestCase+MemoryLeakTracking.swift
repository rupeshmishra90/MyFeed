//
//  XCTestCase+MemoryLeakTracking.swift
//  MyFeedTests
//
//  Created by Rupesh Kumar on 18/08/24.
//

import XCTest

extension XCTestCase{
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line)
    {
        addTeardownBlock {[weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
        
    }
}
