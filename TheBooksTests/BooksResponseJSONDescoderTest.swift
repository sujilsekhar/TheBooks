//
//  BooksResponseJSONDescoderTest.swift
//  TheBooksTests
//
//  Created by Sujil Chandrasekharan on 06/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import XCTest
@testable import TheBooks

class BooksResponseJSONDecoderTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResponseJsonEncoding() {
        
        let jsonData = "{\"status\":\"OK\",\"num_results\":80,\"results\":{\"published_date\":\"2018-12-16\",\"lists\":[{\"list_id\":704,\"books\":[{\"author\":\"Louise Penny\",\"book_image\":\"https:\\\\s1.nyt.com\\du\\books\\images\\9781466873698.jpg\",\"contributor\":\"by Louise Penny\",\"description\":\"While on suspension, Chief Inspector Armand Gamache is made an executor of a strangeR will and tries to keep a deadly narcotic off Montreal streets.\",\"publisher\":\"Minotaur\",\"title\":\"KINGDOM OF THE BLIND\"},{\"author\":\"Nicholas Sparks\",\"book_image\":\"https:\\\\s1.nyt.com\\du\\books\\images\\9781538728529.jpg\",\"contributor\":\"by Nicholas Sparks\",\"description\":\"Difficult choices surface when Hope Anderson and Tru Walls meet in a North Carolina seaside town.\",\"publisher\":\"Grand Central\",\"title\":\"EVERY BREATH\",}]}]}}".data(using: .utf8)
        
        do {
            _ = try JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
            let bookData = try JSONDecoder().decode(BookApiResponse.self, from: jsonData!)
            XCTAssert(bookData.numberOfResults == 2, "Error in decoding JSON data")
            
        }catch {
            
        }
    }    
}
