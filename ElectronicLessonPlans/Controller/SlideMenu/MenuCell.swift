//
//  MenuCell.swift
//  SlideMenuDemo
//
//  Created by Taof on 9/3/19.
//  Copyright © 2019 Taof. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blueInLogo
        return view
    }()
    
    let myTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.addSubview(containerView)
        containerView.addSubview(myTitle)
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        myTitle.frame = containerView.bounds
        myTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    }
    
}
