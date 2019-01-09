//MIT License
//
//Copyright © 2019 Sujil Chandresekharan
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

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
        
        viewModel.getBookList(date: "2019-01-05") { error in
            XCTAssert((viewModel.booklist.value?.count)! > 0, "Get book list service failed")
            serviceExpectation.fulfill()
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
        
        viewModel.getBookList(date: "1900-01-05") { error in
            
            XCTAssert(viewModel.booklist.value == nil, "")
            serviceExpectation.fulfill()
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
        
        viewModel.getBookList(date: "2019-01-05") { error in
            
            viewModel.fetchAllBooks()
            XCTAssert((viewModel.booklist.value?.count)! > 0, "Book fetch failed")
            serviceExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testSearchForBook(){
        
        let book = BookModel()
        
        book.title = "test Title Biography"
        book.author = "test author"
        book.publisher = "test publiser"
        book.contributor = "test contributor"
        book.description = "test description"
        book.bookUrl = "test url"
        
        let viewModel = BooksViewModel()
        viewModel.keyWordIndexer.addBookToIndexSet(book: book)
        viewModel.searchInBooks(searchString: "bio")
        XCTAssertEqual(viewModel.booklist.value?.count, 1, "Error in sarching book")

    }
    
}
