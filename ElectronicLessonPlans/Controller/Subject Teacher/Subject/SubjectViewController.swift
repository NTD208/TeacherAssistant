//
//  SubjectViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/07/2021.
//

import UIKit

class SubjectViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    var nameSubject:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light

        navigationItem.title = nameSubject
        
        self.view.addSubview(tableView)
        setupLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SubjectCell.self, forCellReuseIdentifier: "SubjectCell")
    }

    func setupLayout() {
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

extension SubjectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell") as! SubjectCell
//        cell.lesson = datas[indexPath.row]
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let lessonVC = LessonViewController()
//        lessonVC.lesson = datas[indexPath.row]
//        lessonVC.row = indexPath.row
//        navigationController?.pushViewController(lessonVC, animated: true)
//    }
}
