//
//  SubjectCell.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/07/2021.
//

import UIKit

class SubjectCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var lesson:Lesson? {
        didSet {
            if let lesson = lesson {
                numberLabel.text = "Bài " + "\(lesson.number!):"
                nameLabel.text = lesson.title
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.addSubview(containerView)
        containerView.addSubview(numberLabel)
        containerView.addSubview(nameLabel)
        
        setupLayout()
    }
    
    func setupLayout() {
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        numberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        numberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        
        nameLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
    }
    
}
