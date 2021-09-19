//
//  CardCollectionViewCell.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 07/08/2021.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    let cardImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "BG_Toan")
        return image
    }()
    
    let classLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    var subject:Subject? {
        didSet {
            if let subject = subject {
                classLabel.text = subject.name?.uppercased()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(cardImage)
        cardImage.addSubview(classLabel)

        cardImage.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cardImage.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cardImage.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        cardImage.layer.cornerRadius = 20
        self.clipsToBounds = true
        cardImage.clipsToBounds = true
        
        classLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        classLabel.centerYAnchor.constraint(equalTo: cardImage.centerYAnchor).isActive = true
        classLabel.widthAnchor.constraint(equalTo: cardImage.widthAnchor).isActive = true
        classLabel.heightAnchor.constraint(equalTo: cardImage.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
