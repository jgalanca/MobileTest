/**
  CharacterInfo.swift
  Contains main information about a Character  

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import Foundation

// MARK: - Resource
class Resource: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [ResourceItem]?
    let returned: Int?

    init(available: Int?, collectionURI: String?, items: [ResourceItem]?, returned: Int?) {
        self.available = available
        self.collectionURI = collectionURI
        self.items = items
        self.returned = returned
    }
}

// MARK: - ResourceItem
class ResourceItem: Codable {
    let resourceURI: String?
    let name: String?

    init(resourceURI: String?, name: String?) {
        self.resourceURI = resourceURI
        self.name = name
    }
}

// MARK: - ResourceType
enum ResourceType: String {
    case comics, series, stories
}

// MARK: - Thumbnail
class Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }

    init(path: String?, thumbnailExtension: String?) {
        self.path = path
        self.thumbnailExtension = thumbnailExtension
    }

    var url: URL? {
        if let path = self.path,
           let thumbnailExtension = self.thumbnailExtension {
            return URL(string: "\(path).\(thumbnailExtension)")
        }
        return nil
    }

    var extensionType: Extension {
        if let thumbExtension = self.thumbnailExtension {
            return Extension(rawValue: thumbExtension.lowercased()) ?? .unknown
        }
        return .unknown
    }
}

enum Extension: String, Codable {
    case jpg
    case png
    case gif
    case unknown
}
