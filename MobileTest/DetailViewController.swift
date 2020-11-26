/**
 DetailViewController.swift
  MobileTest

 - Author: Javier Galán <j.galanca.developer@gmail.com>
 - Date: 25/11/2020.
*/
import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet private var tableView: CustomTableView!

    private var character: Character?
    var tableObject: CharacterDetailTableObject = CharacterDetailTableObject(character: nil, delegate: nil)

    init(withCharacter character: Character) {
        super.init(nibName: nil, bundle: nil)
        self.character = character
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.viewSettings()
            self.showSpinner(onView: self.view)
            self.updateCharacterInfo()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Auxiliar Methods
    func setCharacter(_ char: Character) {
        self.character = char
    }

    private func updateCharacterInfo() {
        if let character = self.character {
            self.tableObject = CharacterDetailTableObject(character: character, delegate: self)
            self.tableView.reloadData()
            self.removeSpinner()

            self.tableObject.loadResources(.comics)
            self.tableObject.loadResources(.series)
        }
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        tableObject.tableView(tableView, heightForHeaderInSection: section)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableObject.tableView(tableView, viewForHeaderInSection: section)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        tableObject.numberOfSections(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableObject.tableView(tableView, numberOfRowsInSection: section)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableObject.tableView(tableView, heightForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableObject.tableView(tableView, cellForRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailViewController {
    private func viewSettings() {
        self.view.backgroundColor = .white
        self.tableViewSettings()
    }

    // MARK: Tableview Settings
    private func tableViewSettings() {
        if tableView == nil {
            tableView = CustomTableView(frame: .zero, style: .plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableObject.setUpTableView(tableView: tableView)
            self.view.addSubview(tableView)

            self.addTableViewConstraints()
        }
    }

    private func addTableViewConstraints() {
        if let table = tableView {
            let leadingConstraint = NSLayoutConstraint(
                item: table,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .leading,
                multiplier: 1,
                constant: 0)
            let trailingConstraint = NSLayoutConstraint(
                item: table,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .trailing,
                multiplier: 1,
                constant: 0)
            let topConstraint = table.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
            let bottomConstrant = NSLayoutConstraint(
                item: table,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self.view,
                attribute: .bottom,
                multiplier: 1,
                constant: 0.0)
            NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstrant])
        }
    }
}

extension DetailViewController: CharacterDetailTableObjectDelegate {
    func updateTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func updateTable(section: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: section), with: .none)
        }
    }
}
