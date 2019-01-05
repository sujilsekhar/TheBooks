//
//  BooksResponseDecoder.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

struct BookApiResponse : Decodable{
    
    struct Results: Codable{
        
        struct Lists: Codable{
            
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









