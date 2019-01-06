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

enum LogEvent: String {
    
    case s = "[Severe]" // severe
    case e = "[Error]" // error
    case i = "[Info]" // info
    case d = "[Debug]" // debug
    case v = "[Verbose]" // verbose
    case w = "[Warning]" // warning
    
}

/**
 A generic logger to log with various severity.
 Currently logs into xcode debug window, can be extended to other logging mechanism as required
 */
class Log {
    
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    //Log with a severity of "Severe"
    class func s( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  column: Int = #column,
                  funcName: String = #function) {
        do {
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    //Log with a severity of "Error"
    class func e( _ object: Any,
        filename: String = #file,
        line: Int = #line,
        column: Int = #column,
        funcName: String = #function) {
        do {
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
    //Log with a severity of "Info"
    class func i( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  column: Int = #column,
                  funcName: String = #function) {
        do {
            
            #if DEBUG
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
            #endif
        }
    }
    
    //Log with a severity of "Debug"
    class func d( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  column: Int = #column,
                  funcName: String = #function) {
        do {
            #if DEBUG
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
            #endif
        }
    }
    
    //Log with a severity of "Verbose"
    class func v( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  column: Int = #column,
                  funcName: String = #function) {
        do {
            #if DEBUG
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
            #endif
        }
    }
    
    //Log with a severity of "Warning"
    class func w( _ object: Any,
                  filename: String = #file,
                  line: Int = #line,
                  column: Int = #column,
                  funcName: String = #function) {
        do {
            #if DEBUG
            print("\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
            #endif
        }
    }
    
    
}

extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
