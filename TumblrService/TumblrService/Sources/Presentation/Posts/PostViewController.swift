//
//  PostViewController.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: - Implementation

class PostViewController: UIViewController {
    fileprivate var presenter: PostPresenter!
    @IBOutlet private weak var postsTableView: UITableView!
    @IBOutlet private weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.reuseIdentifier())
    }
    
    // MARK: - Actions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        presenter.handleSearch()
    }
}

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.reuseIdentifier()) as? PostTableViewCell,
        let model = presenter.models[safe: indexPath.row]
        else { return UITableViewCell() }
        
        cell.delegate = self
        cell.populate(with: model)
        
        return cell
    }
}

extension PostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            presenter.handleSearchText(updatedText)
        }
        
        return true
    }
}

extension PostViewController: PostPresenterOutput {
    func handleDataUpdate() {
        postsTableView.reloadData()
    }
    
    func handleItemUpdate(at row: Int, element: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        let cell = postsTableView.cellForRow(at: indexPath) as? PostTableViewCell
        cell?.imagesCollectionView.reloadItems(at: [IndexPath(item: element, section: 0)])
    }
}

extension PostViewController: PostTableViewCellDelegate {
    func postCell(_ cell: PostTableViewCell, id: Int, didSelectAt indexPath: IndexPath) {
        presenter.handleItemSelect(with: id, atIndexPath: indexPath)
    }
}

// MARK: - Factory

final class PostViewControllerFactory {
    static func new(presenter: PostPresenter) -> PostViewController {
        let controller = UIStoryboard.instantiateViewController(type: .post) as! PostViewController
        controller.presenter = presenter
        presenter.output = controller
        return controller
    }
}
