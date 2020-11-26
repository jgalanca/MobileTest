/**
  ViewController.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: CustomTableView!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var navActivityIndicator: UIActivityIndicatorView!

    var items: [AnyObject] = []
    let tableObject: CharacterListTableObject = CharacterListTableObject()
    private var textToSearch: String = ""
    private var isLoadingData: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.viewSettings()
            self.showSpinner(onView: self.view)
            self.loadData(clearData: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Auxiliar Methods
    private func loadData(clearData: Bool) {
        self.showLoadingInNavigation(true)
        isLoadingData = true
        tableObject.updateSearchParams(textToSearch: self.textToSearch, offset: clearData ? 0 : tableObject.nextOffset)
        tableObject.getObjects { result in
            self.removeSpinner()
            self.showLoadingInNavigation(false)
            self.isLoadingData = false
            switch result {
            case .success(let objects):
                DispatchQueue.main.async {
                    self.items.append(contentsOf: objects)
                    if self.items.isEmpty {
                        let alert = UIAlertController(
                            title: "error".localized(),
                            message: "no_data".localized(),
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self.showError(String(describing: error.localizedDescription))
            }
        }
    }

    private func goDetail(character: Character) {
        let detailVC: DetailViewController = DetailViewController(withCharacter: character)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableObject.tableViewCellType().getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableObject.tableView(tableView, cellForRowAt: indexPath, withObject: items[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let character = self.items[indexPath.row] as? Character {
            self.goDetail(character: character)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (tableObject.nextOffset - 10) && !isLoadingData && tableObject.hasMorePages {
            loadData(clearData: false)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.textToSearch = searchBar.text ?? ""
        self.items = []
        self.tableView.reloadData()
        self.loadData(clearData: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        if let text = self.searchBar.text,
            text.isEmpty {
            searchBar.setShowsCancelButton(false, animated: true)
        }
    }
}

extension ViewController {
    private func viewSettings() {
        self.configNavigation()
        self.searchBarSettings()
        self.tableViewSettings()
    }

    // MARK: Navigation Settings
    private func configNavigation() {
        if self.navigationController != nil {
            self.navigationItem.title = "title".localized()
            navActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: navActivityIndicator)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    private func showLoadingInNavigation(_ show: Bool) {
        if let activityIndicator = self.navActivityIndicator {
            show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    // MARK: Tableview Settings
    private func tableViewSettings() {
        if tableView == nil {
            tableView = CustomTableView(frame: .zero, style: .plain)
            tableObject.setUpTableView(tableView: tableView)
            tableView.delegate = self
            tableView.dataSource = self
            self.view.addSubview(tableView)

            self.addTableViewConstraints()
        }
    }

    private func addTableViewConstraints() {
        if let table = tableView {
            let tableLeading = NSLayoutConstraint(
                item: table,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .leading,
                multiplier: 1,
                constant: 0)
            let tableTrailing = NSLayoutConstraint(
                item: table,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0)
            let tableTop = NSLayoutConstraint(
                item: table,
                attribute: .top,
                relatedBy: .equal,
                toItem: self.searchBar,
                attribute: .bottom,
                multiplier: 1,
                constant: 0)
            let tableBottom = NSLayoutConstraint(
                item: table,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0.0)
            NSLayoutConstraint.activate([tableTrailing, tableLeading, tableTop, tableBottom])
        }
    }

    // MARK: Search Settings
    private func searchBarSettings() {
        if searchBar == nil {
            searchBar = UISearchBar(frame: .zero)
            self.searchBar.delegate = self
            self.searchBar.placeholder = "search".localized()

            self.view.addSubview(searchBar)

            self.addSearchBarConstraints()
        }
    }

    private func addSearchBarConstraints() {
        if let sBar = searchBar {
            let leadingConstraint = NSLayoutConstraint(
                item: sBar,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .leading,
                multiplier: 1,
                constant: 0)
            let trailingConstraint = NSLayoutConstraint(
                item: sBar,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0)
            let topConstraint = sBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
            let heightConstraint = sBar.heightAnchor.constraint(equalToConstant: 44.0)
            sBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, heightConstraint])
        }
    }
}
