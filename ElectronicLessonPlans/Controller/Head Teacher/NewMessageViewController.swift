//
//  NewMessageViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/08/2021.
//

import UIKit
import Firebase

class NewMessageViewController: UIViewController {
    
    private let database = Database.database().reference()
    
    let uid = Auth.auth().currentUser?.uid
    
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
        
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Tin nhắn mới"
        navigationController?.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blueInLogo
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellowInLogo]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light
        
        self.view.addSubview(tableView)
        
        tableView.frame = self.view.bounds
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        self.database.child("Users").observe(.childAdded) { snapshort in
            if let dictionary = snapshort.value as? [String: Any] {
                if snapshort.key != self.uid {
                    let user = User()
                    user.id = snapshort.key
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
        if let profileImageUrl = user.profileImageURL {
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
