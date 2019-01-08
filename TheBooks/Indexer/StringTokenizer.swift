//
//  StringTokenizer.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 08/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

class Tokenizer{
    
    static let stopWords = ["a","about","an","are","as","at","be","by","com","de","en","for","from","how","i","in","is","it","la","of","on","or","that","this", "to","was","what","when","where","who","will","with","und","the","www"]
    
    static let minimumWordLength = 2
    
    class func getTokenizedString(string: String, useStopWords: Bool = false)->[String.SubSequence]{
        var loweredString = string.lowercased()
        
        if useStopWords {
            loweredString = loweredString.replacingOccurrences(of: ".,\'", with: "")
        }
        
        let words = loweredString.split{ $0 == " "}
        let filteredWords = words.filter{
            let word = String($0)
            return useStopWords ? $0.count > minimumWordLength && !stopWords.contains(word) : $0.count > minimumWordLength
        }
        return filteredWords
    }
}
