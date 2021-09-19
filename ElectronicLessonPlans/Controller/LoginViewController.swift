//
//  LoginViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 24/06/2021.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class LoginViewController: UIViewController {
        
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
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "du@gmail.com"
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mật khẩu"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "123456"
        return textField
    }()
    
    let forgotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Quên mật khẩu?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Đăng nhập", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return button
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Bạn chưa có tài khoản? Đăng ký ngay.", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let forgotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
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
    
    let phoneView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let passwordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let phoneImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "envelope.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return image
    }()
    
    let passwordImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "lock.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return image
    }()
    
    let eyeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "eye.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return image
    }()
    
    var isShow:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        setupLayout()
        
        underlineTextField(subView: phoneView)
        underlineTextField(subView: passwordView)
        
        forgotLabel.isUserInteractionEnabled = true
        let forgotLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressForgot))
        forgotLabel.addGestureRecognizer(forgotLabelTapGesture)
        
        loginButton.addTarget(self, action: #selector(onPressLogin), for: .touchUpInside)
        
        signUpLabel.isUserInteractionEnabled = true
        let signUpLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressSignUp))
        signUpLabel.addGestureRecognizer(signUpLabelTapGesture)
        
        eyeImage.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressEye))
        eyeImage.addGestureRecognizer(tapGesture)
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
        stackView.addArrangedSubview(phoneView)
        stackView.addArrangedSubview(passwordView)
        
        phoneView.addSubview(phoneImage)
        phoneView.addSubview(phoneTextField)
        
        passwordView.addSubview(passwordImage)
        passwordView.addSubview(passwordTextField)
        passwordView.addSubview(eyeImage)
        
        stackView.addArrangedSubview(forgotView)
        
        forgotView.addSubview(forgotLabel)
        containerView.addSubview(loginButton)
        containerView.addSubview(signUpLabel)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        phoneView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        phoneView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        passwordView.heightAnchor.constraint(equalTo: phoneView.heightAnchor).isActive = true
        passwordView.widthAnchor.constraint(equalTo: phoneView.widthAnchor).isActive = true
        forgotView.heightAnchor.constraint(equalTo: passwordView.heightAnchor).isActive = true
        forgotView.widthAnchor.constraint(equalTo: passwordView.widthAnchor).isActive = true
        
        phoneImage.topAnchor.constraint(equalTo: phoneView.topAnchor).isActive = true
        phoneImage.bottomAnchor.constraint(equalTo: phoneView.bottomAnchor).isActive = true
        phoneImage.leadingAnchor.constraint(equalTo: phoneView.leadingAnchor).isActive = true
        
        phoneTextField.topAnchor.constraint(equalTo: phoneImage.topAnchor).isActive = true
        phoneTextField.bottomAnchor.constraint(equalTo: phoneImage.bottomAnchor).isActive = true
        phoneTextField.trailingAnchor.constraint(equalTo: phoneView.trailingAnchor).isActive = true
        phoneTextField.leadingAnchor.constraint(equalTo: phoneImage.trailingAnchor, constant: 10).isActive = true
        
        passwordImage.topAnchor.constraint(equalTo: passwordView.topAnchor).isActive = true
        passwordImage.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor).isActive = true
        passwordImage.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor).isActive = true
        
        eyeImage.topAnchor.constraint(equalTo: passwordTextField.topAnchor).isActive = true
        eyeImage.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        eyeImage.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: passwordImage.topAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: passwordImage.bottomAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordImage.trailingAnchor, constant: 10).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: eyeImage.leadingAnchor, constant: 10).isActive = true
                
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50).isActive = true
        
        forgotLabel.topAnchor.constraint(equalTo: forgotView.topAnchor).isActive = true
        forgotLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor).isActive = true
        loginButton.layer.cornerRadius = 45/2
        
        signUpLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        signUpLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    @objc func onPressForgot() {
        let forgotVC = ForgotViewController()
        forgotVC.modalPresentationStyle = .fullScreen
        self.present(forgotVC, animated: true, completion: nil)
    }
    
    @objc func onPressLogin() {
        guard let email = phoneTextField.text, let password = passwordTextField.text else { return }
        
        ProgressHUD.show()
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Thông báo", message: "Email hoặc Mật khẩu không chính xác", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            ProgressHUD.dismiss()
            let perInforVC = PerInforViewController()
            let navigationC = UINavigationController(rootViewController: perInforVC)
            navigationC.modalPresentationStyle = .fullScreen
            self.present(navigationC, animated: true) {
                self.phoneTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
    }
    
    @objc func onPressSignUp() {
        let registerVC = SignUpViewController()
        registerVC.modalPresentationStyle = .fullScreen
        self.present(registerVC, animated: true, completion: nil)
    }
    
    func underlineTextField(subView: UIView) {
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
    
    @objc func onPressEye() {
        isShow.toggle()
        if isShow {
            passwordTextField.isSecureTextEntry = false
            eyeImage.image = UIImage(systemName: "eye.slash.fill")
        } else {
            passwordTextField.isSecureTextEntry = true
            eyeImage.image = UIImage(systemName: "eye.fill")
        }
    }
    
    // Chạm vào màn hình để tắt keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
