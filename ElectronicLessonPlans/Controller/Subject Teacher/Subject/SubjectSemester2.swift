//
//  SubjectSemester2.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 23/08/2021.
//

import UIKit
import Firebase

class SubjectSemester2: UIViewController {
    
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
    
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupLayout() {
        self.tabBarController?.overrideUserInterfaceStyle = .light
        
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.9907737374, green: 0.7321282029, blue: 0.08257485181, alpha: 1)]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.addSubview(containerView)
        containerView.addSubview(tableView)
        
        containerView.frame = self.view.bounds
        tableView.frame = containerView.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func handleAdd() {
        print("Add")
    }
    
    @objc func callBack() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SubjectSemester2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = "Bài \(indexPath.row + 1)"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chương \(section + 3)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessVC = LessonViewController()
        lessVC.row = indexPath.row + 1
        navigationController?.pushViewController(lessVC, animated: true)
    }
}
