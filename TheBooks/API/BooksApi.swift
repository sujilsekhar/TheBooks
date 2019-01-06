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

enum ServerEnvironment {
    case dev
    case qa
    case staging
    case production
}

public enum BooksApi {
    case list(date:String)
    
}

/**
    Defines the end point to connect to books api service point
    Encapsulates all the required parameters to connect to end point
 
 
 */

extension BooksApi: EndPointType {
    
    //Environment base url as string
    var environmentBaseURL : String {
        switch ServiceManager.environment {
            case .dev: return "https://api.nytimes.com/svc/books/v2/"
            case .qa: return "https://api.nytimes.com/svc/books/v2/"
            case .staging: return "https://api.nytimes.com/svc/books/v2/"
            case .production: return "https://api.nytimes.com/svc/books/v2/"
        }
    }
    
    // URL encoded base url
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    // REST path to the service
    var servicePath : String {
        switch self {
        case .list:
            return "lists/overview.json"
        }
    }
    
    // Http method
    var httpMethod: HTTPMethod {
        return .get
    }
    
    // request parameters reqiored to connect
    var httpsRequest: HTTPRequest {
        switch self {
        case .list(let date):
            return .requestWithParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["published_date":date,
                                                      "api-key":ServiceManager.APIKey])
        }
    }

    //any additional headers
    var headers: HTTPHeaders? {
        return nil
    }
}

