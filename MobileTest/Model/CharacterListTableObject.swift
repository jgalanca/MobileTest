/**
  CharacterListTableObject.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

class CharacterListTableObject {
    var characterList: CharacterList?
    private var searchText: String = ""
    private var searchOffset: Int = 0

    func updateSearchParams(textToSearch: String, offset: Int) {
        searchText = textToSearch
        searchOffset = offset
    }

    func getCharactersUrl() -> String {
        if let url: URL = URL(string: "\(MarvelApi.basePath)\(MarvelApi.pathCharacters)") {
            var charactersUrl = url
            charactersUrl = charactersUrl.appending(MarvelApi.getCredentials())
            if !self.searchText.isEmpty {
                charactersUrl = charactersUrl.appending("nameStartsWith", value: self.searchText)
            }
            charactersUrl = charactersUrl.appending("offset", value: String("\(self.searchOffset)"))
            charactersUrl = charactersUrl.appending("limit", value: String("\(MarvelApi.limit)"))
            return charactersUrl.absoluteString
        }
        return ""
    }

    var hasMorePages: Bool {
        if let charList = characterList,
           let total = charList.total,
           let offset = charList.offset,
           let limit = charList.limit {
            return total - (offset + limit) > 0
        }
        return false
    }

    var nextOffset: Int {
        if let charList = characterList,
           let offset = charList.offset,
           let limit = charList.limit {
            return hasMorePages ? offset + limit : offset
        }
        return 0
    }

    var limit: Int {
        if let charList = characterList,
           let limit = charList.limit {
            return limit
        }
        return 0
    }
}

extension CharacterListTableObject: CustomTableObjectProtocol {
    func getObjects(completionHandler: @escaping (Result<[AnyObject], Error>) -> Void) {
        guard let request = CharacterListRequest(urlString: self.getCharactersUrl()) else {
            completionHandler(
                .failure(NSError(domain: "Bad Request",
                                 code: 400,
                                 userInfo: [NSLocalizedDescriptionKey: "Malformed Request"]) as Error))
            return
        }

        WebService.sharedInstance.sendRequest(request) { result in
            switch result {
            case .success(let response):
                guard let charResponse = response as? CharacterListResponse,
                      let charData = charResponse.characterListData() else {
                    completionHandler(.success([]))
                    return
                }

                self.characterList = charData.data
                if let characterList = self.characterList {
                    completionHandler(.success(characterList.results ?? []))
                } else {
                    completionHandler(.success([]))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

    func tableViewCellType() -> CustomTableCellProtocol.Type {
        CharacterCell.self
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath,
        withObject object: AnyObject
    ) -> CustomTableCellProtocol {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.getIdentifier(), for: indexPath) as? CharacterCell
        if cell == nil {
            cell = CharacterCell()
        }

        if let charCell = cell as? CharacterCell {
            charCell.setObject(object: object)
            return charCell
        }
        return CharacterCell()
    }

    func setUpTableView(tableView: UITableView) {
        tableView.register(
            UINib(nibName: String(describing: self.tableViewCellType()), bundle: nil),
            forCellReuseIdentifier: self.tableViewCellType().getIdentifier())
    }
}
