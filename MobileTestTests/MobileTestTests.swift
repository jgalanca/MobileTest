/**
 MobileTestTests.swift
 MobileTestTests

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import XCTest
@testable import MobileTest

class WebServiceMock: WebService {
    private var forceError = false

    init(_ forceError: Bool) {
        self.forceError = forceError
    }

    override func sendRequest(
        _ request: WebServiceRequestProtocol,
        completion: @escaping (Result<WebServiceResponse, Error>) -> Void
    ) {
        if forceError {
            completion(.failure(NSError(
                                    domain: "Response Error",
                                    code: -1,
                                    userInfo: [NSLocalizedDescriptionKey: "Froce Error"]) as Error))
            return
        }

        do {
            guard let filePath = Bundle(for: type(of: self)).path(forResource: "response", ofType: "json") else {
                completion(.failure(NSError(
                                        domain: "Response Error",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Invalid File"]) as Error))
                return
            }

            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            let parsedResponse: WebServiceResponse = request.response()
            parsedResponse.setData(data)
            completion(.success(parsedResponse))
        } catch let error {
             completion(.failure(error))
        }
    }
}

class MobileTestTests: XCTestCase {

    func testGetItems() {
        guard let request = CharacterListRequest(urlString: "\(MarvelApi.basePath)\(MarvelApi.pathCharacters)") else {
            XCTFail("Bad Request")
            return
        }

        let promise = expectation(description: "Make Request")

        WebServiceMock(false).sendRequest(request) { result in
            switch result {
            case .success(let response):
                guard let listResponse = response as? CharacterListResponse else {
                    XCTFail("unexpected Response type")
                    return
                }
                XCTAssertNotNil(listResponse.characterListData())
                if let listData = listResponse.characterListData() {
                    XCTAssertNotNil(listData.data)
                    if let data = listData.data {
                        XCTAssertNotNil(data.count)
                        if let count = data.count {
                            XCTAssertNotEqual(count, 0)
                        }
                    }
                }
            case .failure(let error):
                XCTFail("request error: \(String(describing: error.localizedDescription))")
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 10.0) { error in
            if error != nil {
                XCTFail("timeout errored: \(String(describing: error?.localizedDescription))")
            }
        }
    }

    func testGetItemsError() {
        guard let request = CharacterListRequest(urlString: "\(MarvelApi.basePath)\(MarvelApi.pathCharacters)") else {
            XCTFail("Bad Request")
            return
        }

        let promise = expectation(description: "Make Request")

        WebServiceMock(true).sendRequest(request) { result in
            switch result {
            case .success(let response):
                XCTAssertNil(response)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            promise.fulfill()
        }

        waitForExpectations(timeout: 10.0) { error in
            if error != nil {
                XCTFail("timeout errored: \(String(describing: error?.localizedDescription))")
            }
        }
    }

}
