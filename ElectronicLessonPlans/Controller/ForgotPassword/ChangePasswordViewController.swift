//
//  ChangePasswordViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 19/09/2021.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
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
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.spacing = 30
        return stack
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mật khẩu mới"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    
    let rePasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nhập lại mật khẩu mới"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        return textField
    }()
    
    let changeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Đổi mật khẩu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .blueInLogo
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        underlineTextField(subView: passwordTextField)
        underlineTextField(subView: rePasswordTextField)
        
        changeButton.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
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
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(rePasswordTextField)
        
        containerView.addSubview(changeButton)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        rePasswordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50).isActive = true
        stackView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50).isActive = true
        
        changeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        changeButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 75).isActive = true
        changeButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        changeButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        passwordTextField.layer.cornerRadius = 8
        rePasswordTextField.layer.cornerRadius = 8
        changeButton.layer.cornerRadius = 45/2
    }
    
    @objc func handleChange() {
        guard let password = passwordTextField.text, let rePassword = rePasswordTextField.text else { return }
        
        if password == rePassword {
            //
        }
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
}
