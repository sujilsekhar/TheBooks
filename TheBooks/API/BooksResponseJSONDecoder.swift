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

import Foundation


/**
  Defines the structures that are required to parse the JSON response
*/

struct Book : Codable{
    
    let title : String
    let author : String
    let publisher : String
    let contributor : String
    let description  : String
    let bookUrl : String
    
    enum CodingKeys : String, CodingKey{
        case title = "title"
        case author = "author"
        case publisher = "publisher"
        case contributor = "contributor"
        case description = "description"
        case bookUrl = "book_image"
    }
}

struct BookApiResponse : Decodable{
    
    struct Results: Codable{
        
        struct Lists: Codable{
            
            let listId : Int
            let books : [Book]
            
            enum CodingKeys : String, CodingKey{
                case listId = "list_id"
                case books = "books"
            }
        }
        
        let publishedDate : String
        let lists : [Lists]
        
        enum CodingKeys : String, CodingKey{
            case publishedDate = "published_date"
            case lists = "lists"
        }
        
    }
    
    let status: String
    let numberOfResults: Int
    let results : Results
    
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case numberOfResults = "num_results"
        case results = "results"
    }
}



struct BookApiResponseMetaData : Decodable{

    let status: String
    let numberOfResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
        case numberOfResults = "num_results"
    }
}



