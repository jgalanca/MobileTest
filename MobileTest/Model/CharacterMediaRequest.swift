/**
  CharacterMediaRequest.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import Foundation

class CharacterMediaRequest: WebServiceRequestProtocol {
    var type: ResourceType = .comics

    let url: URL

    func body() -> [String: Any] {
        [:]
    }

    func httpMethod() -> HTTPMethod {
        .GET
    }

    func response() -> WebServiceResponse {
        let response = CharacterMediaResponse()
        response.type = self.type
        return response
    }

    init?(urlString: String) {
        guard let url = URL(string: urlString) else {
            return nil
        }
        self.url = url
    }

}

class CharacterMediaResponse: WebServiceResponse {
    var type: ResourceType = .comics

    func characterMediaList() -> CharacterMediaList? {
        if let dataInfo = self.data {
            do {
                let characterMediaData = try CharacterMediaData(data: dataInfo)
                return characterMediaData.data
            } catch {
                return nil
            }
        }
        return nil
    }
}

class CharacterMediaData: Decodable {
    let data: CharacterMediaList?

    init(data: CharacterMediaList?) {
        self.data = data
    }

    convenience init(data: Data) throws {
        let characterMediaData = try JSONDecoder().decode(CharacterMediaData.self, from: data)
        self.init(data: characterMediaData.data)
    }
}

class CharacterMediaList: Decodable {
    let results: [CharacterMedia]?

    init(results: [CharacterMedia]?) {
        self.results = results
    }
}

class CharacterMedia: Decodable {
    let title, mediaDescription: String?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?

    enum CodingKeys: String, CodingKey {
        case title, thumbnail, images
        case mediaDescription = "description"
    }

    init(
        title: String?,
        mediaDescription: String?,
        thumbnail: Thumbnail?,
        images: [Thumbnail]?
    ) {
        self.title = title
        self.mediaDescription = mediaDescription
        self.thumbnail = thumbnail
        self.images = images
    }
}
