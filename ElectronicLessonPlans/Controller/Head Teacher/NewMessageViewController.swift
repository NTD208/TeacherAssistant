//
//  NewMessageViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/08/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class NewMessageViewController: UIViewController {
    
    private let database = Database.database().reference()
    
    var users = [User]()
    
    var messageC: MessageViewController?
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light
//        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Tin nhắn mới"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.9907737374, green: 0.7321282029, blue: 0.08257485181, alpha: 1)]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.addSubview(tableView)
        
        tableView.frame = self.view.bounds
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        self.database.child("Users").observe(.childAdded) { snapshort in
            if let dictionary = snapshort.value as? [String: Any] {
                let user = User()
                user.id = snapshort.key

//                user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.password = dictionary["password"] as? String
                user.dateOfBirth = dictionary["dob"] as? String
                user.profileImageURL = dictionary["profileImage"] as? String
                
                self.users.append(user)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
extension NewMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
//        print(user.profileImageURL as Any)
        if let profileImageUrl = user.profileImageURL {
//            print(profileImageUrl)
            cell.profileImage.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            let url = NSURL(string: profileImageUrl)
            URLSession.shared.dataTask(with: url! as URL) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }

                DispatchQueue.main.async {
                    cell.profileImage.image = UIImage(data: data!)
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messageC?.showChatController(user: user)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
