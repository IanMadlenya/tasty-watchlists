//
//  SymbolSearchViewController.swift
//  TastyWatchlists
//
//  Created by Jason Dimitriou on 7/20/17.
//  Copyright © 2017 Jason Dimitriou. All rights reserved.
//

import UIKit

protocol SymbolSearchDelegate {
    func didSelectSymbol(_ symbol: TastySymbol)
}

class SymbolSearchViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    var delegate: SymbolSearchDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var searchTimer: Timer?
    var searchString: String?
    
    var searchResults: [TastySymbol]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "ID")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fireSearch() {
        if let string = searchString, string.characters.count > 0 {
            searchText(string)
        }
    }
    
    func searchText(_ text: String) {
        TastySymbolSearch.searchSymbolsForString(text, success: { symbols in
            self.searchResults = symbols
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, failure: {
            
        })
    }
    
    // MARK: - Actions
    
    @IBAction func didPressCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension SymbolSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Thanks apple for making Range
        let nsString = textField.text as NSString?
        searchString = nsString?.replacingCharacters(in: range, with: string)

        fireSearch()
        
        return true
    }
}

// MARK: - TableViewDelegate

extension SymbolSearchViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let results = searchResults?[indexPath.row] {
            delegate?.didSelectSymbol(results)
            dismiss(animated: true, completion: nil)
        }
    }
}


//MARK: - TableViewDataSource

extension SymbolSearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = searchResults {
            return results.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID", for: indexPath) as UITableViewCell
        
        if let name = searchResults?[indexPath.row].shortName {
            cell.textLabel?.text = name
        }
        
        return cell
    }
}
