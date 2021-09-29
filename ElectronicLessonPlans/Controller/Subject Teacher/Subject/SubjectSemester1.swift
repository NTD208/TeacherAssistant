//
//  SubjectSemester1.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 23/08/2021.
//

import UIKit
import Firebase

class SubjectSemester1: UIViewController {
    
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
    
//    var lessons = [Lesson]()
    var chapter1 = [Lesson]()
    var chapter2 = [Lesson]()
//    var chapters = [[Lesson]()]
    
    var max = Int.min
    var min = Int.max
    
    var timer: Timer!
    
    var subject:Subject? {
        didSet {
            if let subject = subject {
                navigationItem.title = subject.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        fetchLessons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.backgroundColor = .tabBarColor
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blueInLogo
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellowInLogo]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        
        SubjectSemester2().maxInSemester1 = max
    }
    
    func setupLayout() {
        self.tabBarController?.overrideUserInterfaceStyle = .light
        
        self.view.addSubview(containerView)
        containerView.addSubview(tableView)
        
        containerView.frame = self.view.bounds
        tableView.frame = containerView.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .done, target: self, action: #selector(handleBack))
        
        tableView.delegate = self
        tableView.dataSource = self
//        UITableViewHeaderFooterView.appearance().tintColor = .lightGray
        tableView.tableFooterView = UIView()
        
        tableView.register(SubjectCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func handleAdd() {
        let database = Database.database().reference()
        let alert = UIAlertController(title: "Thêm bài mới", message: "Hoc ki 1", preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Chương"
            tf.keyboardType = .numberPad
        }
        alert.addTextField { tf in
            tf.placeholder = "Số thứ tự bài"
            tf.keyboardType = .numberPad
        }
        alert.addTextField { tf in
            tf.placeholder = "Tên bài"
        }
        
        let submitAction = UIAlertAction(title: "Xong", style: .default) { _ in
            let answer1 = alert.textFields![0].text
            let answer2 = alert.textFields![1].text
            let answer3 = alert.textFields![2].text
            let refLesson = database.child("Lessons").child("Semester1").child(self.navigationItem.title!)
            let childRefLesson = refLesson.childByAutoId()
            let values1 = ["chapter": answer1, "number": answer2, "title": answer3, "owner": self.uid]
            
            childRefLesson.updateChildValues(values1 as [String: Any])
            
            let refDetailLesson = database.child("Detai_Lesson")
            let childRefDetailLesson = refDetailLesson.childByAutoId()
            let values2 = ["general": "Không có", "activityOfTeacher": "Không có", "activityOfStudent": "Không có", "note": "Không có", "owner": childRefLesson.key]
            
            childRefDetailLesson.updateChildValues(values2 as [String: Any])
        }
        
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        alert.preferredAction = submitAction
        present(alert, animated: true) {
            self.fetchLessons()
        }
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }

    func fetchLessons() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Lessons").child("Semester1").child(self.navigationItem.title!)

        ref.observe(.value) { snapshort in

            if let value = snapshort.value as? [String: Any] {
                for key in value.keys {
                    if let dictionary = value[key] as? [String: AnyObject] {
                        if dictionary["owner"] as? String == uid {
                            let lesson = Lesson(dictionary: dictionary, id: key)
                            
                            guard let chapter = lesson.chapter else { return }
                            
                            if Int(chapter)! < self.min {
                                self.min = Int(chapter)!
                            }
                            
                            if Int(chapter)! > self.max {
                                self.max = Int(chapter)!
                            }
                            
                            switch Int(chapter)! {
                            case 1:
                                self.chapter1.append(lesson)
                                self.attemptReloadOfTable()
                            case 2:
                                self.chapter2.append(lesson)
                                self.attemptReloadOfTable()
                            default:
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadTable() {
        self.chapter1.sort { num1, num2 in
            return Int(num1.number!)! < Int(num2.number!)!
        }
        
        self.chapter2.sort { num1, num2 in
            return Int(num1.number!)! < Int(num2.number!)!
        }
        
//        self.chapters.append(self.chapter1)
//        self.chapters.append(self.chapter2)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SubjectSemester1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubjectCell
        
        switch indexPath.section {
        case 0:
            let lesson = chapter1[indexPath.row]
            cell.lesson = lesson
            return cell
        case 1:
            let lesson = chapter2[indexPath.row]
            cell.lesson = lesson
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return max
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return chapter1.count
        case 1:
            return chapter2.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chương \(section + min)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessVC = LessonViewController()
        switch indexPath.section {
        case 0:
            let lesson = chapter1[indexPath.row]
            lessVC.lesson = lesson
            lessVC.row = indexPath.row + 1
            lessVC.owner = lesson.uid
            navigationController?.pushViewController(lessVC, animated: true)
        case 1:
            let lesson = chapter2[indexPath.row]
            lessVC.lesson = lesson
            lessVC.row = indexPath.row + 1
            lessVC.owner = lesson.uid
            navigationController?.pushViewController(lessVC, animated: true)
        default:
            return
        }
        
    }
}
