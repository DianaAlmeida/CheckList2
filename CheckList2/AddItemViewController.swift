//
//  itemDetailViewController.swift
//  CheckList2
//
//  Created by Diana Almeida on 08/08/2023.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table View Delegates
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
}
