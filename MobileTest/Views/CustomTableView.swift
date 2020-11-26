import Foundation
import UIKit

/**
  This class allows the creation of an CustomTableView object with Custom style

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
 */
open class CustomTableView: UITableView {
    /**
    Initializes a new CustomTableView

    - Parameters:
       - aDecoder: The coder of the tableView

    - Returns: A CustomTableView
    */
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customInit()
    }

    /**
    Initializes a new CustomTableView

    - Parameters:
       - frame: The frame of the tableView
       - style: The style of the tableView

    - Returns: A CustomTableView
    */
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.customInit()
    }

    /// Initialize the style of the tableView
    private func customInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin,
            .flexibleBottomMargin, .flexibleWidth, .flexibleHeight
        ]
        self.tableFooterView = UIView()
        self.separatorStyle = .none
        self.backgroundColor = .white
        self.allowsSelection = true
    }
}
/**
 Protocol that must implement all the classes that inherit from this one
 to create a custom Custom Table Object
 */
public protocol CustomTableObjectProtocol {
    /**
     * Method to set up tableview information
     */
    func setUpTableView(tableView: UITableView)

    /**
     * Method to get all objects to be list on a table.
     * @return array of objects, or error if anything fails
     */
    func getObjects(completionHandler: @escaping (Result<[AnyObject], Error>) -> Void)

    /**
     * Method to get the type of cell to be diplayed in table.
     * @return type of the cell
     */
    func tableViewCellType() -> CustomTableCellProtocol.Type

    /**
     * Method to get the cell to be diplayed in table.
     *
     * @param tableView where cell is going to be displayed
     * @param indexPath index of the cell in table
     * @param object object with the information to be setted in cell
     *
     * @return cell to be diplayed.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, withObject object: AnyObject)
        -> CustomTableCellProtocol
}

/**
 Protocol that must implement all the classes that inherit from this one
 to create a custom Custom Table Cell
 */
public protocol CustomTableCellProtocol: UITableViewCell {
    /**
     Method to get the identifier of the cell
     - Returns: String with the identifier
     */
    static func getIdentifier() -> String

    /**
     Method to get the height of the cell
     - Returns: CGFloat with the height
     */
    static func getHeight() -> CGFloat

    /**
     Method to set object information in table
     - Parameters:
        - object: AnyObject object with the information to be setted in cell
     */
    func setObject(object: AnyObject)
}
