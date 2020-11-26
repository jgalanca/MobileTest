/**
  WebService.swift
  Class that contains all the logic to send the request and return a response

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
 */
import Foundation

/** WebService's connection error cases. */
public enum WebServiceConnectionError: Error {
    /** Error indicating that the request could not be conformed. */
    case invalidRequest
    /** Generic error. */
    case unknownError
    
}

public class WebService: NSObject, URLSessionDelegate {
    /**
     * Internal init, used to prevent the use of the default initialized from the outside.
     * This class must be initialized using the `sharedInstance()` function.
     */
    override internal init() {
        super.init()
    }
    
    /**
     * SINGLETON instance of the object
     * @returns the instance created for the object.
     */
    public static let sharedInstance = WebService()
    
    /**
     Makes a request to the web service.
     
     - @param request: a class with the basic @params for the request
     - @param completion: the callback called when the request is successful or fails
     */
    public func sendRequest(
        _ request: WebServiceRequestProtocol,
        completion: (@escaping (Result<WebServiceResponse, Error>) -> Void)
    ) {
        if let urlRequest: URLRequest = WebServiceRequest.createRequest(request) as URLRequest? {
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
            let sessionDataTask = session.dataTask(
                with: urlRequest) { data, response, error -> Void in
                self.checkResponse(
                    data,
                    response: response,
                    error: error) { (result: Result<Bool, Error>) in
                        switch result {
                        case .success(let status):
                            let parsedResponse: WebServiceResponse = request.response()
                            if status == true {
                                parsedResponse.setData(data)
                            }
                            completion(.success(parsedResponse))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                }
            }
            sessionDataTask.resume()

        } else {
            completion(.failure(WebServiceConnectionError.invalidRequest))
        }
    }
    
    private func checkResponse(
        _ data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: (@escaping (Result<Bool, Error>) -> Void)
    ) {
        if let errorInfo = error {
            completion(.failure(errorInfo))
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            let unknownError = NSError(domain: NSURLErrorDomain, code: -1, userInfo: [
                                            NSLocalizedDescriptionKey:
                                            "Unexpected response: \(response?.description ?? "NO RESPONSE")"
            ])
            completion(.failure(unknownError))
            return
        }
        
        if httpResponse.statusCode == 200 {
            completion(.success(true))
        } else {
            let httpError = NSError(domain: NSURLErrorDomain,
                                    code: httpResponse.statusCode,
                                    userInfo: [
                                            NSLocalizedDescriptionKey:
                                            "\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"
                                    ]
            )
            completion(.failure(httpError))
        }
    }
}
