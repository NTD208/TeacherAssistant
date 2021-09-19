//
//  ChatMessageCell.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 12/08/2021.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.isEditable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "avatar")
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let messageImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleToFill
        return image
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleTrailingAnchor: NSLayoutConstraint?
    var bubbleLeadingAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImage)
        bubbleView.addSubview(messageImage)
        
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        bubbleTrailingAnchor?.isActive = true
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubbleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 8)
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8).isActive = true
        textView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        
        messageImage.frame = bubbleView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
