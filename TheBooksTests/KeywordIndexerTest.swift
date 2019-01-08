//
//  KeywordIndexerTest.swift
//  TheBooksTests
//
//  Created by Sujil Chandrasekharan on 08/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import XCTest
@testable import TheBooks

class KeywordIndexerTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBookDataIndexing() {
        let book = BookModel()
        let indexer = KeywordIndexer()
        
        
        book.bookIdentifier = 1
        book.title = "These are first class keywords"
        book.author = "These are second class keywords author"
        book.publisher = "These are second class keywords  publisher"
        book.contributor = "These are second class keywords contributor"
        book.description = "These are third class keywords describtion"
        
        indexer.indexBookData(book: book)
        
        indexer.printCurrentIndex()
        
    }
    
    func testMultipleBookDataIndexing() {
        let book = BookModel()
        let indexer = KeywordIndexer()
        
        
        book.bookIdentifier = 1
        book.title = "These are first class keywords"
        book.author = "These are second class keywords author"
        book.publisher = "These are second class keywords  publisher"
        book.contributor = "These are second class keywords contributor"
        book.description = "These are third class keywords describtion"
        
        indexer.indexBookData(book: book)
        
        book.bookIdentifier = 2
        book.title = "These are first class keywords"
        book.author = "These are second class keywords author"
        book.publisher = "These are second class keywords  publisher"
        book.contributor = "These are second class keywords describtion"
        book.description = "These are third class keywords contributor"
        
        indexer.indexBookData(book: book)
        
        indexer.printCurrentIndex()
        
    }
    
}
