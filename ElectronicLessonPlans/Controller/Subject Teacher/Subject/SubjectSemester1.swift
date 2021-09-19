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
    
    var lessons = [Lesson]()
    var lessonsDictionary = [String: Lesson]()
    
    var timer: Timer!
    
    var subject:Subject? {
        didSet {
            if let subject = subject {
                tabBarController?.navigationItem.title = subject.name
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        tableView.register(SubjectCell.self, forCellReuseIdentifier: "cell")
        
        fetchLessons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupLayout() {
        self.tabBarController?.overrideUserInterfaceStyle = .light
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.blueInLogo
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellowInLogo]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        self.view.addSubview(containerView)
        containerView.addSubview(tableView)
        
        containerView.frame = self.view.bounds
        tableView.frame = containerView.bounds
    }
    
    @objc func handleAdd() {
        let uid = Auth.auth().currentUser?.uid
        let database = Database.database().reference()
        let alert = UIAlertController(title: "Thêm bài mới", message: nil, preferredStyle: .alert)
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
            let refLesson = database.child("Lessons")
            let childRefLesson = refLesson.childByAutoId()
            let values1 = ["chapter": answer1, "number": answer2, "title": answer3, "owner": uid] as! [String: String]
            
            childRefLesson.updateChildValues(values1)
            
            let refDetailLesson = database.child("Detai_Lesson")
            let childRefDetailLesson = refDetailLesson.childByAutoId()
            let values2 = ["general": "Không có", "activityOfTeacher": "Không có", "activityOfStudent": "Không có", "note": "Không có", "owner": childRefLesson.key] as! [String: String]
            
            childRefDetailLesson.updateChildValues(values2)
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

    func fetchLessons() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("Lessons")

        ref.observe(.childAdded) { snapshort in
            let lessonId = snapshort.key
            
            ref.child(lessonId).observe(.value) { [self] snap in
                if let dictionary = snap.value as? [String: AnyObject] {
                    if (dictionary["owner"] as? String) == uid {
                        let lesson = Lesson(dictionary: dictionary, id: lessonId)
                        self.lessonsDictionary[lessonId] = lesson
                        self.attemptReloadOfTable()
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
        self.lessons = Array(self.lessonsDictionary.values)
        
        self.lessons.sort { num1, num2 in
            return Int(num1.number!)! < Int(num2.number!)!
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension SubjectSemester1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SubjectCell
        let lesson = lessons[indexPath.row]
        cell.lesson = lesson
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Chương \(section + 1)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lessVC = LessonViewController()
        let lesson = lessons[indexPath.row]
        lessVC.lesson = lesson
        lessVC.row = indexPath.row + 1
        lessVC.owner = lesson.uid
        navigationController?.pushViewController(lessVC, animated: true)
    }
}
