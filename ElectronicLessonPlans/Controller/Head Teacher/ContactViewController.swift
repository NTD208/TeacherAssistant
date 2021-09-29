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
    
    let menuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .blueInLogo
        return table
    }()
    
    lazy var slideInMenuPadding: CGFloat = view.frame.width * 1/2
    
    var isSlideInMenuPresented = false
    
    let titleInMenu = ["Thông tin cá nhân", "Giáo viên chủ nhiệm", "Giáo viên bộ môn", "Đăng xuất"]

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
//        self.overrideUserInterfaceStyle = .light
//        self.tabBarController?.overrideUserInterfaceStyle = .light
        
//        navigationController?.navigationBar.barStyle = .black
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onPressAdd))
        navigationItem.rightBarButtonItem = addButton
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(tappedMenu))
        navigationItem.leftBarButtonItem = menuButton
        
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.alwaysBounceVertical = false
    }
    
    @objc func onPressAdd() {
        
    }
    
    @objc func tappedMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSlideInMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
            self.tabBarController?.tabBar.frame.origin.x = self.containerView.frame.origin.x
//            self.navigationController?.navigationBar.frame.origin.x = self.containerView.frame.origin.x
        } completion: { finished in
            self.isSlideInMenuPresented.toggle()
        }
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
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
        if tableView == self.tableView {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = "Đang phát triển"
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = titleInMenu[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            return
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
//                self.navigationController?.popToRootViewController(animated: true)
            default:
                break
            }
        }
    }
}
