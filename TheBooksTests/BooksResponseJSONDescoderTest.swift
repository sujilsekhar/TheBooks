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
