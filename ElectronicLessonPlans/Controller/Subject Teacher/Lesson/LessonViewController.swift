//
//  LessonViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 12/07/2021.
//

import UIKit
import UniformTypeIdentifiers
import Firebase

class LessonViewController: UIViewController {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let uploadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let plusImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "plus")
        image.tintColor = .lightGray
        return image
    }()
    
    let nameImage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tải lên file"
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    var lesson:Lesson? {
        didSet {
            if let lesson = lesson {
                navigationItem.title = "Bài \(lesson.number!)"
                titleLabel.text = lesson.title
            }
        }
    }
    
    var owner:String?
    
    var row:Int?
    
//    var datas:[DetailLesson] = detaiLessonData
    var details = [DetailLesson]()
    var detailsDictionary = [String: DetailLesson]()
    
    var timer:Timer!
    
    let database = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(uploadView)
        self.view.addSubview(tableView)
        uploadView.addSubview(plusImage)
        uploadView.addSubview(nameImage)
        
        setupLayout()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LessonCell.self, forCellReuseIdentifier: "LessonCell")
        tableView.tableFooterView = UIView()
        
        plusImage.isUserInteractionEnabled = true
        let tapUploadFile = UITapGestureRecognizer(target: self, action: #selector(uploadFile))
        plusImage.addGestureRecognizer(tapUploadFile)
        
        
        fetchDetailLesson()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupLayout() {
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 25).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        uploadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        uploadView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        uploadView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        uploadView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.4).isActive = true
        
        tableView.topAnchor.constraint(equalTo: uploadView.bottomAnchor, constant: 50).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        plusImage.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
        plusImage.centerYAnchor.constraint(equalTo: uploadView.centerYAnchor, constant: -10).isActive = true
        plusImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        plusImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameImage.centerXAnchor.constraint(equalTo: uploadView.centerXAnchor).isActive = true
        nameImage.centerYAnchor.constraint(equalTo: plusImage.bottomAnchor, constant: 10).isActive = true
        nameImage.widthAnchor.constraint(equalTo: uploadView.widthAnchor, multiplier: 0.8).isActive = true
        nameImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func uploadFile() {
        let supportedTypes: [UTType] = [UTType.text]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func fetchDetailLesson() {
        let ref = database.child("Detai_Lesson")
        ref.observe(.childAdded) { snapshort in
            let detaiId = snapshort.key
            
            ref.child(detaiId).observe(.value) { snap in
                if let dictionary = snap.value as? [String: AnyObject] {
                    if dictionary["owner"] as? String == self.owner {
                        let detail = DetailLesson(dictionary: dictionary)
                        self.detailsDictionary[detaiId] = detail
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
        self.details = Array(self.detailsDictionary.values)
        
        print(details)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension LessonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell") as! LessonCell
//        switch indexPath.section {
//        case 0:
//            cell.descriptionLabel.text = details[1].generalInfo
//        case 1:
//            cell.descriptionLabel.text = details[1].activityOfTeacher
//        case 2:
//            cell.descriptionLabel.text = details[1].activityOfStudent
//        case 3:
//            cell.descriptionLabel.text = details[1].note
//        default:
//            break
//        }
        let detail = details[indexPath.row]
        cell.detail = detail
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = EditViewController()
//        editVC.data = self.datas[row!]
        editVC.section = indexPath.section
        switch indexPath.section {
        case 0:
            editVC.titleHeader = "Thông tin chung"
        case 1:
            editVC.titleHeader = "Hoạt động của giáo viên"
        case 2:
            editVC.titleHeader = "Hoạt động của học sinh"
        case 3:
            editVC.titleHeader = "Các lưu ý"
        default:
            editVC.titleHeader = ""
        }
            
//        editVC.passDetailLesson = { data in
//            self.datas[0] = data
//            self.tableView.reloadData()
//        }
            
            self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Thông tin chung"
        case 1:
            return "Hoạt động của giáo viên"
        case 2:
            return "Hoạt động của học sinh"
        case 3:
            return "Các lưu ý"
        default:
            return ""
        }
    }
}

extension LessonViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            return
        }
        
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
        }
        else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}
