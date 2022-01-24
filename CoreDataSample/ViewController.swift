//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Santhosh on 23/01/22.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var displayTable: UITableView!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var countryText: UITextField!

    
    
    var usersArray: [User]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usersArray = [User]()
        
        self.displayTable.delegate = self
        self.displayTable.dataSource = self
        
        print(self.getDocumentDirectoryPath())
    }
    
    @IBAction func getDataClicked(_ sender: Any) {
        usersArray = DBUtility.getAllUserData()
        displayTable.reloadData()
    }
    

    @IBAction func saveClicked(_ sender: Any) {
        if let name = nameText.text, let email = emailText.text, let password = passwordText.text, let city = cityText.text, let country = countryText.text {
            if !email.isValidEmail() {
                self.showAlert(message: "Please enter a valid email.")
                return
            }
            var userData = UserModel()
            userData.name = name
            userData.email = email
            userData.password = password
           var address = AddressModel()
            address.city = city
            address.country = country
            userData.address = address
            DBModel.saveUser(user: userData)
        } else {
            self.showAlert(message: "Please enter all values to contiue.")
        }
    }
    
    
    
    
    func getDocumentDirectoryPath() -> URL? {
        guard let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return document
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisplayTableViewCellIdentifier", for: indexPath)
        if let cellIs = cell as? DisplayTableViewCell {
            cellIs.setData(data: self.usersArray?[indexPath.row])
        }
        return cell
 
    }
    func showAlert(title: String = "Alert", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            print("Ok Clicked")
        })
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete", handler: { (ac: UIContextualAction, view: UIView, success: @escaping (Bool) -> Void) in
            
            DBUtility.deleteUserWithName(name: self.usersArray?[indexPath.row].name, onDelete: { success in
                print(success)
                DispatchQueue.main.async {
                    self.usersArray?.remove(at: indexPath.row)
                    self.displayTable.reloadData()
                }
            })
            
        })
        delete.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [delete])
        return config
    }
    
}



extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
