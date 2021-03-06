//
//  LoginViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 24/06/2021.
//

import UIKit
import Firebase
import ProgressHUD
//import Toast_Swift

class LoginViewController: UIViewController {
        
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
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
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "du@gmail.com"
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mật khẩu"
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.text = "123456"
        textField.autocorrectionType = .no
        return textField
    }()
    
    let forgotLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Quên mật khẩu?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = .blueInLogo
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Đăng nhập", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = .blueInLogo
        return button
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Bạn chưa có tài khoản? Đăng ký ngay.", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = .blueInLogo
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
        image.tintColor = .blueInLogo
        return image
    }()
    
    let passwordImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "lock.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .blueInLogo
        return image
    }()
    
    let eyeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "eye.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .blueInLogo
        return image
    }()
    
    let errorEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "Email không được bỏ trống"
        return label
    }()
    
    let errorPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "Mật khẩu không được bỏ trống"
        return label
    }()
    
    var isShow:Bool = false
    
    let ref = Database.database().reference().child("Users")
    
    var user:User?
    
    var stackViewCenterYAnchor: NSLayoutConstraint?
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.974270761, green: 0.9642215371, blue: 0.9773648381, alpha: 1).cgColor, #colorLiteral(red: 0.8661997318, green: 0.8461599946, blue: 0.8638817668, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(containerView)
        containerView.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(phoneView)
        stackView.addArrangedSubview(passwordView)
        
        phoneView.addSubview(phoneImage)
        phoneView.addSubview(phoneTextField)
        
        passwordView.addSubview(passwordImage)
        passwordView.addSubview(passwordTextField)
        passwordView.addSubview(eyeImage)
        
        stackView.addArrangedSubview(forgotView)
        
        forgotView.addSubview(forgotLabel)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(signUpLabel)
        scrollView.addSubview(errorEmailLabel)
        scrollView.addSubview(errorPasswordLabel)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        scrollView.frame = self.view.bounds
        
        phoneView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        phoneView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85).isActive = true
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
                
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: 50).isActive = true
        
        forgotLabel.topAnchor.constraint(equalTo: forgotView.topAnchor).isActive = true
        forgotLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1/3).isActive = true
        logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalTo: phoneTextField.heightAnchor).isActive = true
        loginButton.layer.cornerRadius = 45/2
        
        signUpLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        signUpLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        errorEmailLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85).isActive = true
        errorEmailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorEmailLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor).isActive = true
        errorEmailLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        errorPasswordLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85).isActive = true
        errorPasswordLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        errorPasswordLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        errorEmailLabel.isHidden = true
        errorPasswordLabel.isHidden = true
    }
    
    @objc func onPressForgot() {
        let forgotVC = ForgotViewController()
        forgotVC.modalPresentationStyle = .fullScreen
        self.present(forgotVC, animated: true, completion: nil)
    }
    
    @objc func onPressLogin() {
        errorEmailLabel.isHidden = true
        errorPasswordLabel.isHidden = true
        guard let email = phoneTextField.text, let password = passwordTextField.text else { return }
        
        if isValidation(email: email, password: password) {
            ProgressHUD.show()
            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Thông báo", message: "Email hoặc Mật khẩu không chính xác", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                ProgressHUD.dismiss()
                let perInforVC = PerInforViewController()
                let slideVC = SlideMenuViewController()
                let slideMenu = SlideMenuController(mainViewController: UINavigationController(rootViewController: perInforVC), leftMenuViewController: slideVC)
                self.navigationController?.pushViewController(slideMenu, animated: true)
            }
        }
    }
    
    @objc func onPressSignUp() {
        let registerVC = SignUpViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func underlineTextField(subView: UIView) {
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .blueInLogo
        scrollView.addSubview(underlineView)
        
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
    
    func isValidation(email: String, password: String) -> Bool {
        if !email.isEmpty && !password.isEmpty {
            return true
        }
        
        if email.isEmpty {
            self.errorEmailLabel.isHidden = false
        }
        
        if password.isEmpty {
            self.errorPasswordLabel.isHidden = false
        }
        
        return false
    }
    
    // Chạm vào màn hình để tắt keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
