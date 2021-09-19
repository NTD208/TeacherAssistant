//
//  UserCell.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/08/2021.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let second = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: second)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    private func setupNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            let ref = FirebaseDatabase.Database.database().reference().child("Users").child(id)
            ref.observeSingleEvent(of: .value) { snapshort in
                if let dictionary = snapshort.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    
                    if dictionary["profileImage"] as? String != nil {
                        if let profileImageUrl = dictionary["profileImage"] {
                            self.profileImage.loadImageUsingCacheWithUrlString(urlString: profileImageUrl as! String)
                            let url = NSURL(string: profileImageUrl as! String)
                            URLSession.shared.dataTask(with: url! as URL) { data, response, error in
                                if error != nil {
                                    print(error!)
                                    return
                                }

                                DispatchQueue.main.async {
                                    self.profileImage.image = UIImage(data: data!)
                                }
                            }.resume()
                        }
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 80, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        
        detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.crop.circle")
        image.layer.cornerRadius = 24
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImage)
        self.addSubview(timeLabel)
        
        profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
//        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

