/**
  WebServiceRequest.swift
  Base class from which all classes that make requests to web service will inherit

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
 */

import Foundation

/* Const for maximum timeout */
private let requestTimeout: TimeInterval = 60.0

/** Supported HTTP method types. */
public enum HTTPMethod: Int {
    case POST
    case PUT
    case GET
    case DELETE
}

/**
 Protocol that must implement all the classes that inherit from this one
 */
public protocol WebServiceRequestProtocol {
    
    /**
     Method to get request url
     - Returns: Url with the request url
     */
    var url: URL { get }
    
    /**
     Method to get all params that needs to be sent in the request as body
     - Returns: Dictionary with the params needed
     */
    func body() -> [String: Any]
    
    /**
     The HTTP method to use for the request.
     */
    func httpMethod() -> HTTPMethod
    
    /**
     Method to parse the data received after the request.
     
     Optional method.
     - Returns: response manager object
     */
    func response() -> WebServiceResponse
    
}

public class WebServiceRequest: NSObject {

    /* Key for content type*/
    private static let httpContentTypeName: String = "Content-Type"
    /* Value for content type tag*/
    private static let httpContentTypeValue: String = "application/json"
    
    /**
     Method to create a new request with the given parameters
     @param request a class that implements WebServiceRequestProtocol
     
     @return URLRequest the created request object
     */
    public static func createRequest(_ request: WebServiceRequestProtocol) -> URLRequest? {
        var theRequest = URLRequest(url: request.url)
        switch request.httpMethod() {
        case .POST:
            theRequest.httpMethod = "POST"
        case .PUT:
            theRequest.httpMethod = "PUT"
        case .GET:
            theRequest.httpMethod = "GET"
        case .DELETE:
            theRequest.httpMethod = "DELETE"
        }
        
        if request.httpMethod() != .GET {
            theRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.body())
            if theRequest.httpBody != nil {
                theRequest.addValue(self.httpContentTypeValue, forHTTPHeaderField: self.httpContentTypeName)
            }
        }

        theRequest.timeoutInterval = requestTimeout
        
        return theRequest
    }
}
