//
//  ConfirmViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 19/09/2021.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrowshape.turn.up.backward.fill"), for: .normal)
        button.tintColor = .blueInLogo
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mã xác nhận đã được gửi về thuê bao"
        label.textColor = .blueInLogo
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.3)
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nhập mã OTP"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Xác nhận", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .blueInLogo
        return button
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var phone:String?
    
    var timer:Timer!
    
    var time = 150

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        setupInfoLabel()
        
        phoneLabel.text = phone
        
        underlineTextField(subView: codeTextField)
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.974270761, green: 0.9642215371, blue: 0.9773648381, alpha: 1).cgColor, #colorLiteral(red: 0.8661997318, green: 0.8461599946, blue: 0.8638817668, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(containerView)
        containerView.addSubview(logoImage)
        containerView.addSubview(backButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(phoneLabel)
        containerView.addSubview(codeTextField)
        containerView.addSubview(statusLabel)
        containerView.addSubview(sendButton)
        containerView.addSubview(infoLabel)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        phoneLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        phoneLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        phoneLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        phoneLabel.bottomAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: phoneLabel.topAnchor, constant: -5).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -50).isActive = true
        
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        codeTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        codeTextField.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 15).isActive = true
        codeTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        codeTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        statusLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        statusLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        statusLabel.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sendButton.layer.cornerRadius = 45/2
        
        infoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 30).isActive = true
        infoLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSend() {
        let changePasswordVC = ChangePasswordViewController()
        changePasswordVC.modalPresentationStyle = .fullScreen
        present(changePasswordVC, animated: true, completion: nil)
    }
    
    @objc func countdown() {
        if time == 0 {
            statusLabel.text = "Mã OTP đã hết hạn."
            statusLabel.textColor = .red
            timer.invalidate()
        } else {
            statusLabel.text = "Mã OTP sẽ hết hạn sau " + "\(time)" + "s"
            time -= 1
        }
    }
    
    func setupInfoLabel() {
        infoLabel.numberOfLines = 0
        var textArray = [String]()
        var fontArray = [UIFont]()
        let colorArray = [UIColor.black, UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)]
        textArray.append("Không nhận được mã OTP?")
        textArray.append("Gửi lại")
        fontArray.append(UIFont.systemFont(ofSize: 18))
        fontArray.append(UIFont.systemFont(ofSize: 18))
        infoLabel.attributedText = getAttributedString(arrayText: textArray, arrayColors: colorArray, arrayFonts: fontArray)
        
        infoLabel.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        infoLabel.addGestureRecognizer(tapgesture)
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.infoLabel.text else { return }
        let conditionsRange = (text as NSString).range(of: "Gửi lại")
        
        if gesture.didTapAttributedTextInLabel(label: self.infoLabel, inRange: conditionsRange) {
            time = 150
        }
    }
    
    func getAttributedString(arrayText:[String]?, arrayColors:[UIColor]?, arrayFonts:[UIFont]?) -> NSMutableAttributedString {
        let finalAttributedString = NSMutableAttributedString()
        for i in 0 ..< (arrayText?.count)! {
            var attributes: [NSAttributedString.Key : Any]?
            
            if arrayText?[i] == "Gửi lại" {
                attributes = [NSAttributedString.Key.foregroundColor: arrayColors?[i] as Any, NSAttributedString.Key.font: arrayFonts?[i] as Any, .underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
            } else {
                attributes = [NSAttributedString.Key.foregroundColor: arrayColors?[i] as Any, NSAttributedString.Key.font: arrayFonts?[i] as Any]
            }
            let attributedStr = (NSAttributedString.init(string: arrayText?[i] ?? "", attributes: attributes))
            if i != 0 {
                finalAttributedString.append(NSAttributedString.init(string: " "))
            }
            
            
            finalAttributedString.append(attributedStr)
        }
        return finalAttributedString
    }
    
    func underlineTextField(subView: UITextField) {
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .blueInLogo
        containerView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -5),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 4
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}
