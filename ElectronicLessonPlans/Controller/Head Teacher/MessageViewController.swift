//
//  MessageViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 17/07/2021.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    let cellId = "cellId"
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        observeUserMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        navigationItem.title = "Tin nhắn"
        navigationController?.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blueInLogo
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellowInLogo]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    func  setupLayout() {
        self.overrideUserInterfaceStyle = .light
        self.tabBarController?.overrideUserInterfaceStyle = .light
                
        let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(onPressAdd))
        navigationItem.rightBarButtonItem = addButton
        
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        
        containerView.edgeTo(view)
        
        containerView.addSubview(tableView)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func onPressAdd() {
        let newMessageVC = NewMessageViewController()
        newMessageVC.messageC = self
        let navigationC = UINavigationController(rootViewController: newMessageVC)
        //        navigationC.modalPresentationStyle = .fullScreen
        self.present(navigationC, animated: true, completion: nil)
    }
    
    func showChatController(user: User) {
        let chatLogC = ChatLogController()
        chatLogC.user = user
        navigationController?.pushViewController(chatLogC, animated: true)
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("User-Messages").child(uid)
        
        ref.observe(.childAdded, with: { snapshort in
            let userId = snapshort.key
            
            Database.database().reference().child("User-Messages").child(uid).child(userId).observe(.childAdded, with: { snapshort in
                let messageId = snapshort.key
                
                self.fetchMessageWithMessageId(messageId: messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    @objc func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        
        self.messages.sort { message1, message2 in
            return message1.timestamp!.intValue > message2.timestamp!.intValue
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messagesReference = Database.database().reference().child("Messages").child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { snapshort in
            if let dictionary = snapshort.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return messages.count
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 72
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else { return }
        let ref = Database.database().reference().child("Users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { snapshort in
            guard let dictionary = snapshort.value as? [String: AnyObject] else {
                return
            }
            let user = User()
            user.id = chatPartnerId
            user.name = dictionary["name"] as? String
            user.email = dictionary["email"] as? String
            user.password = dictionary["password"] as? String
            user.dateOfBirth = dictionary["dob"] as? String
            user.profileImageURL = dictionary["profileImage"] as? String
            self.showChatController(user: user)
        }, withCancel: nil)
    }
}
