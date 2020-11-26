/**
  CharacterDetailTableObject.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

enum CharacterDetailType: Int {
    case unknown = -1
    case image = 0
    case name = 1
    case description = 2
    case comics = 3
    case series = 4

    func asString() -> String {
        switch self {
        case .image:
            return "image".localized()
        case .name:
            return "name".localized()
        case .description:
            return "description".localized()
        case .comics:
            return "comics".localized()
        case .series:
            return "series".localized()
        default:
            return "unknown"
        }
    }

    init(withString string: String) {
        switch string {
        case "image":
            self = .image
        case "name":
            self = .name
        case "description":
            self = .description
        case "comics":
            self = .comics
        case "series":
            self = .series
        default:
            self = .unknown
        }
    }
}

/**
 Protocol that implement the classes that has an object that conforms CharacterDetailTableObject and
 want to catch its events
 */
public protocol CharacterDetailTableObjectDelegate: NSObjectProtocol {
    /**
     * Method to update table information
     */
    func updateTable()

    /**
     * Method to update the information of a section in the table
     * @param section to update
     */
    func updateTable(section: Int)
}

class CharacterDetailTableObject {
    var character: Character?
    var items: [Int: [GenericCellItem]] = [:]
    var comicItems: [CharacterMedia] = []
    var serieItems: [CharacterMedia] = []
    weak var delegate: CharacterDetailTableObjectDelegate?

    init(character: Character?, delegate: CharacterDetailTableObjectDelegate?) {
        self.character = character
        self.delegate = delegate
        self.characterDetailToTableItems()
    }

    func characterDetailToTableItems() {
        if let character = self.character {
            items[CharacterDetailType.image.rawValue] = []
            items[CharacterDetailType.name.rawValue] = [
                GenericCellItem(key: CharacterDetailType.name.asString(), title: character.name)
            ]
            var characterDescription: String?
            if let description = character.characterDescription,
               !description.isEmpty {
                characterDescription = description
            }
            items[CharacterDetailType.description.rawValue] = [
                GenericCellItem(key: CharacterDetailType.description.asString(),
                                title: characterDescription ?? "no_information".localized())
            ]
            var itemsForComics: [GenericCellItem] = []
            if !comicItems.isEmpty {
                for item in comicItems {
                    itemsForComics.append(MediaCellItem(key: item.title ?? CharacterDetailType.comics.asString(),
                                                        media: item))
                }
            } else {
                itemsForComics.append(GenericCellItem(key: CharacterDetailType.comics.asString(),
                                                      title: "no_information".localized()))
            }
            items[CharacterDetailType.comics.rawValue] = itemsForComics
            var itemsForSeries: [GenericCellItem] = []
            if !serieItems.isEmpty {
                for item in serieItems {
                    itemsForSeries.append(MediaCellItem(key: item.title ?? CharacterDetailType.comics.asString(),
                                                        media: item))
                }
            } else {
                itemsForSeries.append(GenericCellItem(key: CharacterDetailType.series.asString(),
                                                      title: "no_information".localized()))
            }
            items[CharacterDetailType.series.rawValue] = itemsForSeries
        }
    }

    func getCharacterMediaUrl(_ type: ResourceType, forCharacterId charId: Int) -> String {
        if let url: URL = URL(string: "\(MarvelApi.basePath)\(MarvelApi.pathCharacters)/\(charId)/\(type.rawValue)") {
            var charactersUrl = url
            charactersUrl = charactersUrl.appending(MarvelApi.getCredentials())
            return charactersUrl.absoluteString
        }
        return ""
    }

    func loadResources(_ type: ResourceType) {
        guard let character = self.character,
              let charId = character.id,
              let request = CharacterMediaRequest(urlString: self.getCharacterMediaUrl(type, forCharacterId: charId))
        else {
            print("load media fail: Malformed Request")
            return
        }
        request.type = type
        WebService.sharedInstance.sendRequest(request) { result in
            switch result {
            case .success(let response):
                guard let charResponse = response as? CharacterMediaResponse else {
                    return
                }
                if let items = charResponse.characterMediaList(),
                   let results = items.results,
                   !results.isEmpty {
                    switch charResponse.type {
                    case .comics:
                        self.comicItems = results
                    case .series:
                        self.serieItems = results
                    default:
                        break
                    }
                    self.characterDetailToTableItems()
                    if let delegate = self.delegate {
                        delegate.updateTable(
                            section: CharacterDetailType(withString: charResponse.type.rawValue).rawValue)
                    }
                }
            case .failure(let error):
                print("load media fail \(error.localizedDescription)")
            }
        }
    }
}

extension CharacterDetailTableObject: CustomTableObjectProtocol {
    func getObjects(completionHandler: @escaping (Result<[AnyObject], Error>) -> Void) {
        completionHandler(.success([]))
    }

    func tableViewCellType() -> CustomTableCellProtocol.Type {
        GenericCell.self
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath,
        withObject object: AnyObject
    ) -> CustomTableCellProtocol {
        var cell: CustomTableCellProtocol?
        if let items = items[indexPath.section] {
            if items[indexPath.row] is MediaCellItem {
                if let mediaCell = tableView.dequeueReusableCell(withIdentifier: MediaCell.getIdentifier(),
                                                                 for: indexPath) as? MediaCell {
                    mediaCell.setObject(object: (items[indexPath.row]))
                    cell = mediaCell
                }
            } else {
                if let genericCell = tableView.dequeueReusableCell(withIdentifier: GenericCell.getIdentifier(),
                                                                   for: indexPath) as? GenericCell {
                    genericCell.setObject(object: (items[indexPath.row]))
                    genericCell.textLabel?.numberOfLines = 0
                    cell = genericCell
                }
            }
        }

        if let customCell = cell {
            return customCell
        }

        return GenericCell(style: .default, reuseIdentifier: GenericCell.getIdentifier())
    }

    func setUpTableView(tableView: UITableView) {
        tableView.register(
            UINib(nibName: String(describing: MediaCell.self), bundle: nil),
            forCellReuseIdentifier: MediaCell.getIdentifier())
        tableView.register(GenericCell.self, forCellReuseIdentifier: GenericCell.getIdentifier())
    }
}

extension CharacterDetailTableObject {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if items.count >= section,
           section == CharacterDetailType.image.rawValue {
            return 250.0
        }
        return 40.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if items.count >= section {
            if section == CharacterDetailType.image.rawValue {
                let header: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 250.0))
                header.contentMode = .scaleToFill
                header.download(image: character?.thumbnail?.url)
                return header
            } else {
                let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 50.0))
                label.backgroundColor = UIColor(red: 231.0 / 255.0, green: 0.0 / 255.0, blue: 31.0 / 255.0, alpha: 1.0)
                label.textColor = .white
                label.font = .boldSystemFont(ofSize: 16.0)
                label.text = CharacterDetailType(rawValue: section)?.asString() ?? ""
                return label
            }
        }
        return nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        Array(items.keys).count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = items[section] {
            return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let items = items[indexPath.section] {
            if items[indexPath.row] is MediaCellItem {
                return MediaCell.getHeight()
            } else if let title = items[indexPath.row].title {
                return GenericCell.getHeight() + title.height(withConstrainedWidth: tableView.frame.size.width,
                                                              font: GenericCell().textLabel?.font ??
                                                                .systemFont(ofSize: 14.0))
            }
        }

        return GenericCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CustomTableCellProtocol {
        if let items = items[indexPath.section] {
            return self.tableView(tableView, cellForRowAt: indexPath, withObject: items[indexPath.row])
        }
        return GenericCell(style: .default, reuseIdentifier: GenericCell.getIdentifier())
    }
}
