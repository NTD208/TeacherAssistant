//
//  ForgotViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 19/09/2021.
//

import UIKit
import Firebase

class ForgotViewController: UIViewController {
    
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
        label.text = "Vui lòng nhập số điện thoại đã đăng ký tài khoản."
        label.textColor = .blueInLogo
        label.font = UIFont.systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "du@gmail.com"
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Gửi mã xác nhận", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .blueInLogo
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        underlineTextField(subView: phoneTextField)
        
        backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
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
        containerView.addSubview(phoneTextField)
        containerView.addSubview(sendButton)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 75).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -20).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/3).isActive = true
        logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -50).isActive = true
        
        backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        phoneTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        phoneTextField.topAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 15).isActive = true
        phoneTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        phoneTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        sendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        sendButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        sendButton.layer.cornerRadius = 45/2
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSend() {
        Auth.auth().sendPasswordReset(withEmail: phoneTextField.text!) { error in
            if error != nil {
                let alert = UIAlertController(title: "Thông báo", message: "Địa chỉ email không chính xác.", preferredStyle: .alert)
                
                let submitAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.phoneTextField.text = nil
                }
                
                alert.addAction(submitAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let alert = UIAlertController(title: "Thông báo", message: "Hãy truy cập đường link được gửi trong email để đổi mật khẩu.", preferredStyle: .alert)
            
            let submitAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true) {
                    self.phoneTextField.text = nil
                }
            }
            
            alert.addAction(submitAction)
            self.present(alert, animated: true, completion: nil)
            
//            let confirmVC = ConfirmViewController()
//            confirmVC.phone = self.phoneTextField.text
//            confirmVC.modalPresentationStyle = .fullScreen
//            self.present(confirmVC, animated: true) {
//                self.phoneTextField.text = nil
//            }
        }
    }
    
    func underlineTextField(subView: UITextField) {
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
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
