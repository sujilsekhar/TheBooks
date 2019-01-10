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
        
        
        book.bookIdentifier = ShortCodeGenerator.generate(length: 6)
        book.title = "These are first class keywords"
        book.author = "These are second class keywords author"
        book.publisher = "These are second class keywords  publisher"
        book.contributor = "These are second class keywords contributor"
        book.description = "These are least class keywords describtion"
        
        indexer.addBookToIndexSet(book: book)
        
        XCTAssert(indexer.keywordIndexSet["first"]!.first?.rank == 1)
        XCTAssert(indexer.keywordIndexSet["second"]!.first?.rank == 2)
        XCTAssert(indexer.keywordIndexSet["least"]!.first?.rank == 3)
        
    }
    
    func testMultipleBookDataIndexing() {
        let book = BookModel()
        let indexer = KeywordIndexer()
        
        
        book.bookIdentifier = ShortCodeGenerator.generate(length: 6)
        book.title = "These are first class keywords publisher"
        book.author = "These are second class keywords author"
        book.publisher = "These are second class keywords  publisher"
        book.contributor = "These are second class keywords contributor"
        book.description = "These are third class keywords description"
        
        let firstBookId = book.bookIdentifier
        
        indexer.addBookToIndexSet(book: book)
        
        XCTAssert(indexer.keywordIndexSet["publisher"]!.first?.rank == 1)
        XCTAssert(indexer.keywordIndexSet["author"]!.first?.rank == 2)
        XCTAssert(indexer.keywordIndexSet["description"]!.first?.rank == 3)
        
        
        book.bookIdentifier = ShortCodeGenerator.generate(length: 6)
        book.title = "These are first class keywords"
        book.author = "These are second class keywords author"
        book.publisher = "These are second class keywords  publisher"
        book.contributor = "These are second class keywords describtion"
        book.description = "These are third class keywords contributor"
        
        let secondBookId = book.bookIdentifier
        
        indexer.addBookToIndexSet(book: book)
        
        XCTAssert(indexer.keywordIndexSet["publisher"]!.contains(IndexItem(id:firstBookId, rank:1)) &&
                  indexer.keywordIndexSet["publisher"]!.contains(IndexItem(id:secondBookId, rank:2)))
        
        XCTAssert(indexer.keywordIndexSet["author"]!.contains(IndexItem(id:firstBookId, rank:2)) &&
            indexer.keywordIndexSet["author"]!.contains(IndexItem(id:secondBookId, rank:2)))
        
    }
    
}
