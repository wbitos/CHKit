//
//  ApiExcutor.swift
//  CHKit
//
//  Created by 王义平 on 2020/9/28.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import ReactiveCocoa
import ReactiveSwift

open class ApiExcutor: NSObject {
    public static var shared: ApiExcutor = ApiExcutor()
    open var domain: String? = nil
    
    open class Http {
        public enum Method: String {
            case get = "GET"
            case post = "POST"
            case put = "PUT"
            case head = "HEAD"
            case options = "OPTIONS"
            case delete = "DELETE"
            case trace = "TRACE"
            case patch = "PATCH"
            case connect = "CONNECT"
        }
    }
    
    public override init() {
        super.init()
    }
    
    public init(domain: String) {
        self.domain = domain
        super.init()
    }
    
    open class Request: CHModel {
        open var schema: String = "https"
        open var domain: String? = nil
        open var method: Http.Method? = nil
        open var headers: [String: String]? = nil
        open var path: String? = nil
        open var parameters: [String: Any] = [:]
        
        open func url() -> String {
            let url = "\(self.schema)://\(self.domain ?? "")\(self.path ?? "")"
            if self.method == Http.Method.post {
                return url
            }
            if self.parameters.count == 0 {
                return url
            }
            let query = self.parameters.map({ (arg0) -> String in
                let (key, value) = arg0
                if let strValue = value as? String {
                    return "\(key)=\(strValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.afURLQueryAllowed) ?? "")"
                }
                return "\(key)=\(value)"
            }).joined(separator: "&")
            return "\(url)?\(query)"
        }
        
        public override init() {
            super.init()
        }
        
        required public init?(map: Map) {
            super.init(map: map)
            schema = (try? map.value("schema")) ?? "https"
            domain = try? map.value("domain")
            method = try? map.value("method")
            headers = try? map.value("headers")
            path = try? map.value("path")
            parameters = (try? map.value("parameters")) ?? [:]
        }
        
        open override func mapping(map: Map) {
            super.mapping(map: map)
            schema <- map["schema"]
            domain <- map["domain"]
            method <- map["method"]
            headers <- map["headers"]
            parameters <- map["parameters"]
        }
        
        open func httpHeaders() -> HTTPHeaders? {
            guard let headers = self.headers else {
                return nil
            }
            return HTTPHeaders(headers)
        }
        
        open func httpMethod() -> HTTPMethod {
            return HTTPMethod(rawValue: self.method?.rawValue ?? Http.Method.get.rawValue)
        }
        
        @discardableResult
        open func set(domain: String) -> Self {
            self.domain = domain
            return self
        }
        
        @discardableResult
        open func set(method: Http.Method) -> Self {
            self.method = method
            return self
        }
        
        @discardableResult
        open func set(path: String) -> Self {
            self.path = path
            return self
        }
        
        @discardableResult
        open func set(parameters: [String: Any]) -> Self {
            self.parameters = parameters
            return self
        }
        
        @discardableResult
        open func set(headers: [String: String]) -> Self {
            self.headers = headers
            return self
        }
        
        @discardableResult
        open func set(header: String, value: String) -> Self {
            var headers = self.headers ?? [:]
            headers[header] = value
            return self.set(headers: headers)
        }
        
        open func request<T: Response>(excutor: ApiExcutor = ApiExcutor.shared) -> SignalProducer<T?, Never>  {
            return excutor.excute(request: self)
        }
    }
    
    open class Response: CHModel {
        required public init?(map: Map) {
            super.init(map: map)
        }
        
        open override func mapping(map: Map) {
            super.mapping(map: map)
        }
    }
    
    open class StateResponse: Response {
        public enum State: String {
            case ok = "ok"
            case failed = "failed"
            case error = "error"
        }
        
        open var state: State = .failed
        open var message: String?
        open var reason: String?
        
        required public init?(map: Map) {
            super.init(map: map)
            message = try? map.value("message")
            reason = try? map.value("reason")
            state = (try? map.value("state")) ?? .failed
        }
        
        open override func mapping(map: Map) {
            super.mapping(map: map)
            message <- map["message"]
            reason <- map["reason"]
            state <- map["state"]
        }
    }
    
    open class DataStateResponse<T: Mappable>: StateResponse {
        open var data: T? = nil

        required public init?(map: Map) {
            super.init(map: map)
            data = (try? map.value("data"))
        }
        
        open override func mapping(map: Map) {
            super.mapping(map: map)
            data <- map["data"]
        }
    }
    
    open class Middleware: NSObject {
        open func handle(excutor: ApiExcutor, request: ApiExcutor.Request) -> Bool {
            return true
        }
    }
    
    open var middlewares: [Middleware] = []
    
    init(middlewares: [Middleware] = []) {
        self.middlewares = middlewares
        super.init()
    }
    
    open func excute<T: CHModel>(request: Request) -> SignalProducer<T?, Never> {
        // <T: CHModel>
        for i in 0..<self.middlewares.count {
            let middleware = self.middlewares[i]
            if !middleware.handle(excutor: self, request: request) {
                break
            }
        }
        if request.httpMethod() == .get {
            return SignalProducer<T?, Never> { (observer, _) in
                let request = AF.request(request.url(), method: request.httpMethod(), parameters: nil, headers: request.httpHeaders(), interceptor: nil)
                request.responseObject { (response: DataResponse<T, AFError>) in
                    guard let value = try? response.result.get() else {
                        observer.send(value: nil)
                        return
                    }
                    observer.send(value: value)
                }
            }
        }
        
        return SignalProducer<T?, Never> { (observer, _) in
            let request = AF.request(request.url(), method: request.httpMethod(), parameters: request.parameters, headers: request.httpHeaders(), interceptor: nil)
            request.responseObject { (response: DataResponse<T, AFError>) in
                guard let value = try? response.result.get() else {
                    observer.send(value: nil)
                    return
                }
                observer.send(value: value)
            }
        }
    }
}
