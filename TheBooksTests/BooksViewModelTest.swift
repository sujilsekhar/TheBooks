//
//  BooksViewModelTest.swift
//  TheBooksTests
//
//  Created by Sujil Chandrasekharan on 06/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import XCTest
@testable import TheBooks

class BooksViewModelTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetBookList() {
        let viewModel = BooksViewModel()
        
        let serviceExpectation = expectation(description: "Bookservice call expectation")
        
        do{
            try viewModel.openDatabase()
            viewModel.getBookList(date: "2019-01-05") { error in
                
                XCTAssert((viewModel.booklist.value?.count)! > 0, "Get book list service failed")
                serviceExpectation.fulfill()
            }
        }catch(let error){
            XCTAssertEqual(error.localizedDescription, nil, "Get book list service failed")
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetBookListNoData() {
        let viewModel = BooksViewModel()
        
        let serviceExpectation = expectation(description: "Bookservice call expectation")
        
        do{
            try viewModel.openDatabase()
            viewModel.getBookList(date: "1900-01-05") { error in
                
                XCTAssert(viewModel.booklist.value == nil, "")
                serviceExpectation.fulfill()
            }
        }catch(let error){
            XCTAssertEqual(error.localizedDescription, nil, "Get book list service failed")
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFetchBookList() {
        let viewModel = BooksViewModel()
        
        let serviceExpectation = expectation(description: "Bookservice call expectation")
        
        do{
            try viewModel.openDatabase()
            viewModel.getBookList(date: "2019-01-05") { error in
                
                viewModel.fetchAllBooks()
                XCTAssert((viewModel.booklist.value?.count)! > 0, "Book fetch failed")
                serviceExpectation.fulfill()
            }
        }catch(let error){
            XCTAssertEqual(error.localizedDescription, nil, "Get book list service failed")
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSearchForBook(){
        
        var error:String?
        
        let book = Book(title: "test Title Biography", author: "test author", publisher: "test publiser", contributor: "test contributor", description: "test description", bookUrl: "test url")
        let viewModel = BooksViewModel()
        do{
            try viewModel.openDatabase()
            viewModel.deleteBooks()
            try viewModel.booksRepository.insertBook(book: book)
            viewModel.searchInBooks(searchString: "bio")
            XCTAssertEqual(viewModel.booklist.value?.count, 1, "Error in sarching book")
        }catch(let message){
            error = message.localizedDescription
        }
        XCTAssertEqual(error, nil, "Error in fetching record")
    }
    
}
