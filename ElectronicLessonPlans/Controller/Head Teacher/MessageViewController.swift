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
    
    let menuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return table
    }()
        
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    let cellId = "cellId"
    
    var timer: Timer?
    
    lazy var slideInMenuPadding: CGFloat = view.frame.width * 1/2
    
    var isSlideInMenuPresented = false
    
    let titleInMenu = ["Thông tin cá nhân", "Giáo viên chủ nhiệm", "Giáo viên bộ môn", "Đăng xuất"]

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        observeUserMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func  setupLayout() {
        self.overrideUserInterfaceStyle = .light
        self.tabBarController?.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationItem.hidesBackButton = true

        navigationItem.title = "Tin nhắn"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.9907737374, green: 0.7321282029, blue: 0.08257485181, alpha: 1)]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(onPressAdd))
        navigationItem.rightBarButtonItem = addButton
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(tappedMenu))
        navigationItem.setLeftBarButton(menuButton, animated: false)
        
        menuView.pinMenuTo(view, with: slideInMenuPadding)
        containerView.edgeTo(view)
        
        containerView.addSubview(tableView)
        
        menuView.addSubview(menuTableView)
        menuTableView.topAnchor.constraint(equalTo: menuView.topAnchor).isActive = true
        menuTableView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        menuTableView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor).isActive = true
        menuTableView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor).isActive = true
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    @objc func onPressAdd() {
        let newMessageVC = NewMessageViewController()
        newMessageVC.messageC = self
        let navigationC = UINavigationController(rootViewController: newMessageVC)
//        navigationC.modalPresentationStyle = .fullScreen
        self.present(navigationC, animated: true, completion: nil)
    }
    
    @objc func tappedMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSlideInMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
        } completion: { finished in
            self.isSlideInMenuPresented.toggle()
        }
    }
    
    func showChatController(user: User) {
//        messages.removeAll()
//        messagesDictionary.removeAll()
//        tableView.reloadData()
        
//        observeUserMessages()
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
            let message = messages[indexPath.row]
            cell.message = message
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = titleInMenu[indexPath.row]
            return cell
        }
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
        if tableView == self.tableView {
            let message = messages[indexPath.row]
            guard let chatPartnerId = message.chatPartnerId() else { return }
            let ref = Database.database().reference().child("Users").child(chatPartnerId)
            ref.observeSingleEvent(of: .value, with: { snapshort in
                guard let dictionary = snapshort.value as? [String: AnyObject] else {
                    return
                }
                let user = User()
                user.id = chatPartnerId
//              user.setValuesForKeys(dictionary)
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.password = dictionary["password"] as? String
                user.dateOfBirth = dictionary["dob"] as? String
                user.profileImageURL = dictionary["profileImage"] as? String
                self.showChatController(user: user)
            }, withCancel: nil)
        } else {
            switch indexPath.row {
            case 0:
                let perInfoVC = UINavigationController(rootViewController: PerInforViewController())
                perInfoVC.modalPresentationStyle = .fullScreen
                self.present(perInfoVC, animated: true, completion: nil)
            case 1:
                break
            case 2:
                let mainVC = UINavigationController(rootViewController: MainScreenViewController())
                mainVC.modalPresentationStyle = .fullScreen
                self.present(mainVC, animated: true, completion:  nil)
            case 3:
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
}
