/**
  WebServiceResponse.swift
  Base class that will inherit all classes wich manage web service responses.
  The class will handle the response returned by the requests

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import Foundation

open class WebServiceResponse: NSObject {
    public var data: Data? /** @property data with the main information of the response*/
    public var dictionary: [String: Any] /** @property dictionary with the main information of the response*/
    public var error: Error? /** @property NSError error returned as response*/
    
    /**
     Create a WebServiceResponse with the given params
     
     @param data the data object of the request
     
     @returns the instance created for the object
     */
    convenience init(_ data: Data?) {
        self.init()
        self.setData(data)
    }

    override public init() {
        self.dictionary = [:]
        super.init()
    }
    
    /**
     Set value to WebServiceResponse properties
     
     @param data the data object of the request
     */
    public func setData(_ data: Data?) {
        if let dataInfo = data {
            do {
                self.data = dataInfo
                guard let json = try JSONSerialization.jsonObject(with: dataInfo, options: []) as?
                        [String: Any] else {
                    return
                }
                self.dictionary = json
            } catch {
                self.error = error
            }
        }
    }
}
