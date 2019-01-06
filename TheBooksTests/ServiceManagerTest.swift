//
//  ServiceManagerTest.swift
//  TheBooksTests
//
//  Created by Sujil Chandrasekharan on 06/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import XCTest
@testable import TheBooks

class ServiceManagerTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetBookListApi() {
        let serviceManager = ServiceManager()
        let serviceExpectation = expectation(description: "Bookservice call expectation")
        
        serviceManager.getBookList(date: "2019-01-05") { (apiResponse, error) in
            XCTAssert((apiResponse?.results.lists[0].books.count)! > 0, "Get books api failed")
            serviceExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetBookListApiNoData() {
        let serviceManager = ServiceManager()
        let serviceExpectation = expectation(description: "Bookservice call expectation")
        
        serviceManager.getBookList(date: "1990-01-05") { (apiResponse, error) in
            XCTAssert(error == NetworkResponse.noData.rawValue, "Get books api no data failed")
            serviceExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
}
