/**
  CharacterCell.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

class CharacterCellItem: GenericCellItem {
    var character: Character

    init(key: String? = nil, enabled: Bool? = true, character: Character) {
        self.character = character
        super.init(key: key ?? character.name ?? "", enabled: enabled, title: character.name ?? "")
    }
}

class CharacterCell: GenericCell {
    @IBOutlet private var charNameLabel: UILabel?
    @IBOutlet private var charImageView: UIImageView?
    private static let cellIdentifier: String = "CharacterCellId"
    private static let cellHeight: CGFloat = 80.0
    private var character: Character?

    init() {
        super.init(style: .default, reuseIdentifier: CharacterCell.getIdentifier())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func getCurrentValue() -> String {
        if let character = self.character {
            return character.name ?? ""
        }
        return ""
    }

    //Métodos auxiliares
    override static func getIdentifier() -> String {
        CharacterCell.cellIdentifier
    }

    override static func getHeight() -> CGFloat {
        CharacterCell.cellHeight
    }

    override func setObject(object: AnyObject) {
        if let characterInfo = object as? CharacterCellItem {
            self.character = characterInfo.character
            self.updateCharInfo()
        } else if let character = object as? Character {
            self.character = character
            self.updateCharInfo()
        }
    }

    private func updateCharInfo() {
        if let character = self.character {
            self.charNameLabel?.text = character.name
            self.charImageView?.download(image: character.thumbnail?.url)
        }
    }
}
