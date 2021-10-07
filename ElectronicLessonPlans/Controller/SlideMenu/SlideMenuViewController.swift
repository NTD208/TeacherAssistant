//
//  SlideMenuViewController.swift
//  SlideMenuDemo
//
//  Created by Taof on 9/3/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit
import Firebase

class SlideMenuViewController: UIViewController {

    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teacher Assistant"
        label.textAlignment = .center
        label.text = label.text?.uppercased()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .yellowInLogo
        return label
    }()
    
    let titleInMenu = ["Thông tin cá nhân", "Giáo viên chủ nhiệm", "Giáo viên bộ môn", "Đăng xuất"]
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blueInLogo
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .blueInLogo
        tableView.bounces = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .blueInLogo
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
    }
}

extension SlideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleInMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = titleInMenu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {                
        switch indexPath.row {
        case 0:
            slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: PerInforViewController()), close: true)
        case 1:
            let tabBarC = UITabBarController()
            let contactVC = UINavigationController(rootViewController: ContactViewController())
            let messageVC = UINavigationController(rootViewController: MessageViewController())
            
            tabBarC.setViewControllers([contactVC, messageVC], animated: true)
            contactVC.title = "Danh bạ"
            contactVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
            contactVC.tabBarItem.badgeValue = "N+"
            messageVC.title = "Tin nhắn"
            messageVC.tabBarItem.image = UIImage(systemName: "message.fill")
            messageVC.tabBarItem.badgeValue = "N+"
            
            slideMenuController()?.changeMainViewController(tabBarC, close: true)
        case 2:
            slideMenuController()?.changeMainViewController(UINavigationController(rootViewController: MainScreenViewController()), close: true)
        case 3:
            try? Auth.auth().signOut()
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
}
