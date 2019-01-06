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

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

/**
 Manages all the service interaction through end point routers.
 Extendable to any number of services by defining different endpoints and routers
 */
class ServiceManager {
    
    //Currently the service configuration are kept in the code
    //TODO: Move to a more configurable place like plist or a settings bundle
    static let environment : ServerEnvironment = .production
    static let APIKey = "76363c9e70bc401bac1e6ad88b13bd1d"
    
    //Router to connect to Books API endpoint
    let endPointRouterBookList = EndPointRouter<BooksApi>()
    
    //retreive the book list thorugh router
    func getBookList(date: String, completion: @escaping (_ booksResponse: BookApiResponse?,_ error: String?)->()){
        
        //Initiate request on enpoint router
        endPointRouterBookList.request(.list(date: date)) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        
                        //serialize response to check for malformed json
                        _ = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        //decode the JSON for metadata first
                        let apiResponse = try JSONDecoder().decode(BookApiResponseMetaData.self, from: responseData)
                        
                        //if metadata have results then decode rest
                        if apiResponse.numberOfResults > 0 {
                            //decode complete api response
                            let apiResponse = try JSONDecoder().decode(BookApiResponse.self, from: responseData)
                            completion(apiResponse,nil)
                        }else{
                            completion(nil, NetworkResponse.noData.rawValue)
                        }
                    }catch {
                        print(error)
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    print("error")
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    //maps network errors to human readable text
    private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}

