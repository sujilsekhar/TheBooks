//
//  BookRepositoryTest.swift
//  TheBooksTests
//
//  Created by Sujil Chandrasekharan on 06/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import XCTest
@testable import TheBooks

class BookRepositoryTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        //continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        //XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOpenDatabase() {
        let bookrepository = BooksRepository()
        var error:String?
        do{
            try bookrepository.openDatabase()
        }catch(let message){
            error = message.localizedDescription
        }
        XCTAssertEqual(error, nil, "DB falied to open")
    }
    
    func testInsertBook() {
        var error:String?
        
        let book = Book(title: "test Title", author: "test author", publisher: "test publiser", contributor: "test contributor", description: "test description", bookUrl: "test url")
        let bookrepository = BooksRepository()
        do{
            try bookrepository.openDatabase()
            try bookrepository.insertBook(book: book)
        }catch(let message){
            error = message.localizedDescription
        }
        XCTAssertEqual(error, nil, "Error in inserting record")
    }
    
    func testFetchBook(){
        
        var error:String?
        
        let book = Book(title: "test Title", author: "test author", publisher: "test publiser", contributor: "test contributor", description: "test description", bookUrl: "test url")
        let bookrepository = BooksRepository()
        do{
            try bookrepository.openDatabase()
            try bookrepository.deleteBooks()
            try bookrepository.insertBook(book: book)
            let books = try bookrepository.fetch()
            XCTAssertEqual(books?.count, 1, "Error in fetching record")
        }catch(let message){
            error = message.localizedDescription
        }
        XCTAssertEqual(error, nil, "Error in fetching record")
    }
    
    func testSearchBook(){
        
        var error:String?
        
        let book = Book(title: "test Title Biography", author: "test author", publisher: "test publiser", contributor: "test contributor", description: "test description", bookUrl: "test url")
        let bookrepository = BooksRepository()
        do{
            try bookrepository.openDatabase()
            try bookrepository.deleteBooks()
            try bookrepository.insertBook(book: book)
            let books = try bookrepository.search(text: "bio")
            XCTAssertEqual(books?.count, 1, "Error in searching book")
        }catch(let message){
            error = message.localizedDescription
        }
        XCTAssertEqual(error, nil, "Error in fetching record")
    }
    
    
    
}
