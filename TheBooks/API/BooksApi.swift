//
//  BooksApi.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

enum ServerEnvironment {
    case dev
    case qa
    case staging
    case production
}

public enum BooksApi {
    case list(date:String)
    
}

extension BooksApi: EndPointType {
    
    var environmentBaseURL : String {
        switch ServiceManager.environment {
            case .dev: return "https://api.nytimes.com/svc/books/v2/"
            case .qa: return "https://api.nytimes.com/svc/books/v2/"
            case .staging: return "https://api.nytimes.com/svc/books/v2/"
            case .production: return "https://api.nytimes.com/svc/books/v2/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var servicePath : String {
        switch self {
        case .list:
            return "lists/overview.json"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var httpsRequest: HTTPRequest {
        switch self {
        case .list(let date):
            return .requestWithParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["published_date":date,
                                                      "api-key":ServiceManager.APIKey])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

