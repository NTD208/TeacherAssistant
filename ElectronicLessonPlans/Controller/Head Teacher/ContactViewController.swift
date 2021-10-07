//
//  ContactViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 17/07/2021.
//

import Contacts
import ContactsUI
import UIKit

class ContactViewController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.backgroundColor = .tabBarColor
        navigationItem.title = "Danh bạ"
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
                
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onPressAdd))
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
        }
    
    @objc func onPressAdd() {
        
    }
}

extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Đang phát triển"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
