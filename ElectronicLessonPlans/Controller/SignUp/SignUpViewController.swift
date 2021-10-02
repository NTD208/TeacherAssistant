//
//  SignUpViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 24/06/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ProgressHUD

class SignUpViewController: UIViewController {
    
    private let database = Database.database().reference()
    
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
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Họ và tên"
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.autocorrectionType = .no
        return tf
    }()
    
    let dobTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Ngày sinh"
//        textField.keyboardType = .numberPad
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let dobPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
//        textField.keyboardType = .numberPad
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Mật khẩu"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let rePasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Nhập lại mật khẩu"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Đăng ký", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return button
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(string: "Bạn đã có tài khoản? Đăng nhập.", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.textColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.spacing = 20
        return stack
    }()
    
    let nameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let dobView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
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
    
    let rePasswordView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    let nameImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "textformat.alt")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return image
    }()
    
    let dobImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "calendar")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return image
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
    
    let rePasswordImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "lock.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        return image
    }()
    
    let errorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "Họ và tên không được bỏ trống"
        return label
    }()
    
    let errorDOBLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "Ngày sinh không được bỏ trống"
        return label
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
    
    let errorRePasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textAlignment = .left
        label.text = "Xác nhận mật khẩu không được bỏ trống"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width + 100, height: view.bounds.height + 100)
        gradientLayer.colors = [#colorLiteral(red: 0.974270761, green: 0.9642215371, blue: 0.9773648381, alpha: 1).cgColor, #colorLiteral(red: 0.8661997318, green: 0.8461599946, blue: 0.8638817668, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(containerView)
        containerView.addSubview(logoImage)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameView)
        stackView.addArrangedSubview(dobView)
        stackView.addArrangedSubview(phoneView)
        stackView.addArrangedSubview(passwordView)
        stackView.addArrangedSubview(rePasswordView)
        
        nameView.addSubview(nameImage)
        nameView.addSubview(nameTextField)
        
        dobView.addSubview(dobImage)
        dobView.addSubview(dobTextField)
        
        phoneView.addSubview(phoneImage)
        phoneView.addSubview(phoneTextField)
        
        passwordView.addSubview(passwordImage)
        passwordView.addSubview(passwordTextField)
        
        rePasswordView.addSubview(rePasswordImage)
        rePasswordView.addSubview(rePasswordTextField)
        
        containerView.addSubview(signUpButton)
        containerView.addSubview(loginLabel)
        containerView.addSubview(errorNameLabel)
        containerView.addSubview(errorDOBLabel)
        containerView.addSubview(errorEmailLabel)
        containerView.addSubview(errorPasswordLabel)
        containerView.addSubview(errorRePasswordLabel)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        nameView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        nameView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        dobView.heightAnchor.constraint(equalTo: nameView.heightAnchor).isActive = true
        dobView.widthAnchor.constraint(equalTo: nameView.widthAnchor).isActive = true
        phoneView.heightAnchor.constraint(equalTo: dobView.heightAnchor).isActive = true
        phoneView.widthAnchor.constraint(equalTo: dobView.widthAnchor).isActive = true
        passwordView.heightAnchor.constraint(equalTo: phoneView.heightAnchor).isActive = true
        passwordView.widthAnchor.constraint(equalTo: phoneView.widthAnchor).isActive = true
        rePasswordView.heightAnchor.constraint(equalTo: passwordView.heightAnchor).isActive = true
        rePasswordView.widthAnchor.constraint(equalTo: passwordView.widthAnchor).isActive = true
        
        nameImage.topAnchor.constraint(equalTo: nameView.topAnchor).isActive = true
        nameImage.bottomAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
        nameImage.leadingAnchor.constraint(equalTo: nameView.leadingAnchor).isActive = true
        
        nameTextField.topAnchor.constraint(equalTo: nameImage.topAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameImage.bottomAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: nameView.trailingAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: nameImage.trailingAnchor, constant: 10).isActive = true
        
        dobImage.topAnchor.constraint(equalTo: dobView.topAnchor).isActive = true
        dobImage.bottomAnchor.constraint(equalTo: dobView.bottomAnchor).isActive = true
        dobImage.leadingAnchor.constraint(equalTo: dobView.leadingAnchor, constant: 0.001).isActive = true
        
        dobTextField.topAnchor.constraint(equalTo: dobImage.topAnchor).isActive = true
        dobTextField.bottomAnchor.constraint(equalTo: dobImage.bottomAnchor).isActive = true
        dobTextField.trailingAnchor.constraint(equalTo: dobView.trailingAnchor).isActive = true
        dobTextField.leadingAnchor.constraint(equalTo: dobImage.trailingAnchor, constant: 10).isActive = true
        
        phoneImage.topAnchor.constraint(equalTo: phoneView.topAnchor).isActive = true
        phoneImage.bottomAnchor.constraint(equalTo: phoneView.bottomAnchor).isActive = true
        phoneImage.leadingAnchor.constraint(equalTo: phoneView.leadingAnchor, constant: 0.002).isActive = true
        
        phoneTextField.topAnchor.constraint(equalTo: phoneImage.topAnchor).isActive = true
        phoneTextField.bottomAnchor.constraint(equalTo: phoneImage.bottomAnchor).isActive = true
        phoneTextField.trailingAnchor.constraint(equalTo: phoneView.trailingAnchor).isActive = true
        phoneTextField.leadingAnchor.constraint(equalTo: phoneImage.trailingAnchor, constant: 10).isActive = true
        
        passwordImage.topAnchor.constraint(equalTo: passwordView.topAnchor).isActive = true
        passwordImage.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor).isActive = true
        passwordImage.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 0.003).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: passwordImage.topAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: passwordImage.bottomAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: passwordImage.trailingAnchor, constant: 10).isActive = true
        
        rePasswordImage.topAnchor.constraint(equalTo: rePasswordView.topAnchor).isActive = true
        rePasswordImage.bottomAnchor.constraint(equalTo: rePasswordView.bottomAnchor).isActive = true
        rePasswordImage.leadingAnchor.constraint(equalTo: rePasswordView.leadingAnchor, constant: 0.004).isActive = true
        
        rePasswordTextField.topAnchor.constraint(equalTo: rePasswordImage.topAnchor).isActive = true
        rePasswordTextField.bottomAnchor.constraint(equalTo: rePasswordImage.bottomAnchor).isActive = true
        rePasswordTextField.trailingAnchor.constraint(equalTo: rePasswordView.trailingAnchor).isActive = true
        rePasswordTextField.leadingAnchor.constraint(equalTo: rePasswordImage.trailingAnchor, constant: 10).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
        logoImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImage.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/3).isActive = true
        logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor).isActive = true
        logoImage.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 75).isActive = true
        signUpButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        signUpButton.heightAnchor.constraint(equalTo: rePasswordView.heightAnchor).isActive = true
        signUpButton.layer.cornerRadius = 45/2
        
        loginLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        loginLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        errorNameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        errorNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorNameLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        errorNameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        errorDOBLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        errorDOBLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorDOBLabel.topAnchor.constraint(equalTo: dobTextField.bottomAnchor).isActive = true
        errorDOBLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        errorEmailLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        errorEmailLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorEmailLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor).isActive = true
        errorEmailLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        errorPasswordLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        errorPasswordLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        errorPasswordLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        errorRePasswordLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        errorRePasswordLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorRePasswordLabel.topAnchor.constraint(equalTo: rePasswordTextField.bottomAnchor).isActive = true
        errorRePasswordLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        dobTextField.inputView = dobPicker
        dobTextField.inputAccessoryView = createToolbar()
        
        underlineTextField(subView: nameView)
        underlineTextField(subView: dobView)
        underlineTextField(subView: phoneView)
        underlineTextField(subView: passwordView)
        underlineTextField(subView: rePasswordView)
        
        errorNameLabel.isHidden = true
        errorDOBLabel.isHidden = true
        errorEmailLabel.isHidden = true
        errorPasswordLabel.isHidden = true
        errorRePasswordLabel.isHidden = true
                
        loginLabel.isUserInteractionEnabled = true
        let labelTapGesture = UITapGestureRecognizer(target: self, action: #selector(onPressLoginLabel))
        loginLabel.addGestureRecognizer(labelTapGesture)
        
        signUpButton.addTarget(self, action: #selector(onPressSignUp), for: .touchUpInside)
    }
    
    @objc func onPressLoginLabel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onPressSignUp() {
        errorNameLabel.isHidden = true
        errorDOBLabel.isHidden = true
        errorEmailLabel.isHidden = true
        errorPasswordLabel.isHidden = true
        errorRePasswordLabel.isHidden = true
        
        guard let name = nameTextField.text, let dob = dobTextField.text, let email = phoneTextField.text, let password = passwordTextField.text, let repassword = rePasswordTextField.text else { return }

        if isValidation(name: name, dob: dob, email: email, password: password, rePassword: repassword) {
            ProgressHUD.show()
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Thông báo", message: "Email không đúng định dạng hoặc đã tồn tại", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    ProgressHUD.dismiss()
                    print(error!)
                    return
                }
                let usersDatabase = self.database.child("Users").child((authResult?.user.uid)!)
                let acc = ["name":name, "dob": dob, "email": email, "password": password]
                usersDatabase.updateChildValues(acc) { (err, data) in
                    if err != nil {
                        print(err!)
                        return
                    }
                }
                let perInforVC = PerInforViewController()
                self.navigationController?.pushViewController(perInforVC, animated: true)
                ProgressHUD.dismiss()
            }
        }
    }
    
    func isValidation(name: String, dob: String, email: String, password: String, rePassword: String) -> Bool {
        if !name.isEmpty && !dob.isEmpty && !email.isEmpty && !password.isEmpty && !rePassword.isEmpty && password == rePassword {
            return true
        }
        
        if name.isEmpty {
            errorNameLabel.isHidden = false
        }
        
        if dob.isEmpty {
            errorDOBLabel.isHidden = false
        }
        
        if email.isEmpty {
            errorEmailLabel.isHidden = false
        }
        
        if password.isEmpty {
            errorPasswordLabel.isHidden = false
        }
        
        if password != rePassword {
            errorRePasswordLabel.isHidden = false
            errorRePasswordLabel.text = "Mật khẩu không khớp"
        }
        
        if rePassword.isEmpty {
            errorRePasswordLabel.isHidden = false
        }
        
        return false
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
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onPressDone))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc func onPressDone() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dobTextField.text = dateFormatter.string(from: dobPicker.date)
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
