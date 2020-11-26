/**
  GenericCell.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

class GenericCellItem {
    var key: String
    var enabled: Bool = true
    var title: String?

    init(key: String, enabled: Bool? = true, title: String? = nil) {
        self.key = key
        self.title = title
        self.enabled = true
        if let enabledValue = enabled {
            self.enabled = enabledValue
        }
    }
}

class GenericCell: UITableViewCell, CustomTableCellProtocol {
    private static let cellIdentifier: String = "cellId"
    private static let cellHeight: CGFloat = 44.0

    internal var item: GenericCellItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewSettings()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //Métodos auxiliares
    var isEnabled: Bool {
        if self.item != nil {
            return self.item.enabled
        }
        return false
    }

    func getCurrentValue() -> String {
        self.item.title ?? ""
    }

    func getCurrentKey() -> String {
        self.item.key
    }

    class func getIdentifier() -> String {
        GenericCell.cellIdentifier
    }

    class func getHeight() -> CGFloat {
        GenericCell.cellHeight
    }

    func setObject(object: AnyObject) {
        viewSettings()
        if let item = object as? GenericCellItem {
            self.item = item
            if let title = self.item.title {
                self.textLabel?.text = title
            } else {
                self.textLabel?.text = self.item.key.localized()
            }
        }
    }

    private func viewSettings() {
        self.accessoryType = .none
        self.textLabel?.textColor = .black
        self.backgroundColor = .white
    }
}
