/**
  CharacterList.swift
  Contains main information about a Character List and its content

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

class CharacterList: Codable {

    let offset, limit, total, count: Int?
    let results: [Character]?

    init(offset: Int?, limit: Int?, total: Int?, count: Int?, results: [Character]?) {
        self.offset = offset
        self.limit = limit
        self.total = total
        self.count = count
        self.results = results
    }
}

// MARK: - Character
class Character: Codable {
    let id: Int?
    let name, characterDescription: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let comics, series, stories: Resource?

    enum CodingKeys: String, CodingKey {
        case id, name
        case characterDescription = "description"
        case thumbnail, resourceURI, comics, series, stories
    }

    init(
        id: Int?,
        name: String?,
        characterDescription: String?,
        thumbnail: Thumbnail?,
        resourceURI: String?,
        comics: Resource?,
        series: Resource?,
        stories: Resource?
    ) {
        self.id = id
        self.name = name
        self.characterDescription = characterDescription
        self.thumbnail = thumbnail
        self.resourceURI = resourceURI
        self.comics = comics
        self.series = series
        self.stories = stories
    }
}
