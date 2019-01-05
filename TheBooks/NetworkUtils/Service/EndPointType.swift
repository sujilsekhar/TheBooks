//
//  EndPointType.swift
//  TheBooks
//
//  Created by Sujil Chandrasekharan on 05/01/19.
//  Copyright © 2019 Sujil Chandrasekharan. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL : URL { get }
    var servicePath : String { get }
    var httpMethod : HTTPMethod { get }
    var headers : HTTPHeaders? { get }
    var httpsRequest : HTTPRequest { get }
}
