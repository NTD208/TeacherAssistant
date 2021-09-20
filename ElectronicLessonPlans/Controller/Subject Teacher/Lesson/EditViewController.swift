//
//  EditViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 18/07/2021.
//

import UIKit

class EditViewController: UIViewController {
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let descriptionTextView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = .white
        return textView
    }()
    
    var titleHeader:String?
    var data:DetailLesson?
    var section:Int?
    var passDetailLesson:((DetailLesson) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = titleHeader
        
        setupLayout()
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveData))
        navigationItem.rightBarButtonItem = saveButton
        
        guard let data = data else {
            return
        }
        
        switch section {
        case 0:
            descriptionTextView.text = data.generalInfo
        case 1:
            descriptionTextView.text = data.activityOfTeacher
        case 2:
            descriptionTextView.text = data.activityOfStudent
        case 3:
            descriptionTextView.text = data.note
        default:
            return
        }

    }
    
    func setupLayout() {
        self.view.addSubview(containerView)
        containerView.addSubview(descriptionTextView)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
        descriptionTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        descriptionTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10).isActive = true
    }
    
    @objc func saveData() {
//        guard let description = descriptionTextView.text else { return }
        
//        navigationController?.popViewController(animated: true)
        
        let alert = UIAlertController(title: "Thông báo", message: "Lưu lại các thay đổi", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Lưu", style: .default) { _ in
            //
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        alert.preferredAction = submitAction
        present(alert, animated: true, completion: nil)
    }
}
