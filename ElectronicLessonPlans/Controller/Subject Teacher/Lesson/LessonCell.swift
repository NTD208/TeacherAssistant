//
//  LessonCell.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 13/07/2021.
//

import UIKit

class LessonCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var detail: DetailLesson? {
        didSet {
            if let detail = detail {
                descriptionLabel.text = detail.generalInfo
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setupLayout()
        descriptionLabel.numberOfLines = 2
    }
    
    func setupLayout() {
        self.addSubview(containerView)
        containerView.addSubview(descriptionLabel)
        
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
    }
}
