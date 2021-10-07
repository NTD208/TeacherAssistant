//
//  SplashViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 15/07/2021.
//

import UIKit

class SplashViewController: UIViewController {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let logoImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "logo")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let myLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Teacher Assistant"
        label.textAlignment = .center
        label.text = label.text?.uppercased()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    var timer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.974270761, green: 0.9642215371, blue: 0.9773648381, alpha: 1).cgColor, #colorLiteral(red: 0.8661997318, green: 0.8461599946, blue: 0.8638817668, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(containerView)
        containerView.addSubview(logoImageView)
        containerView.addSubview(myLabel)
        
        setupLayout()
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToLogin), userInfo: nil, repeats: true)
    }
    
    func setupLayout() {
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -100).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1/3).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor).isActive = true
        
        myLabel.centerXAnchor.constraint(equalTo: logoImageView.centerXAnchor).isActive = true
        myLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 50).isActive = true
        myLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    @objc func goToLogin() {
        timer.invalidate()
        let loginVC = UINavigationController(rootViewController: LoginViewController())
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}
