//
//  HTTPRequest.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPRequest {
    case request
    
    case requestWithParameters(bodyParameters: Parameters?,
                               bodyEncoding: ParameterEncoder,
                               urlParameters: Parameters?)
    
    case requestWithParametersAndHeaders(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoder,
                                         urlParameters: Parameters?,
                                         additionHeaders: HTTPHeaders?)
}


