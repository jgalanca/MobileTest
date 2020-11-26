/**
  CharacterListRequest.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import Foundation

class CharacterListRequest: WebServiceRequestProtocol {
    let url: URL

    func body() -> [String: Any] {
        [:]
    }

    func httpMethod() -> HTTPMethod {
        .GET
    }

    func response() -> WebServiceResponse {
        CharacterListResponse()
    }

    init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            return nil
        }
        self.url = url
    }

}

class CharacterListResponse: WebServiceResponse {
    func characterListData() -> CharacterListData? {
        if let dataInfo = self.data {
            do {
                return try CharacterListData(data: dataInfo)
            } catch {
                return nil
            }
        }
        return nil
    }
}

class CharacterListData: Decodable {
    let code: Int?
    let status: String?
    let data: CharacterList?

    init(
        code: Int?,
        status: String?,
        data: CharacterList?
    ) {
        self.code = code
        self.status = status
        self.data = data
    }

    convenience init(data: Data) throws {
        let charListData = try JSONDecoder().decode(CharacterListData.self, from: data)
        self.init(
            code: charListData.code,
            status: charListData.status,
            data: charListData.data
        )
    }
}
