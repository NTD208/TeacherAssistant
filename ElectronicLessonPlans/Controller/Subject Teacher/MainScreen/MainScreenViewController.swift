//
//  MainScreenViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 24/06/2021.
//

import UIKit
import Firebase

class MainScreenViewController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        flowLayout.scrollDirection = .vertical
        view.backgroundColor = .clear
        return view
    }()
    
    let menuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .blueInLogo
        return table
    }()
    
    let myPage: UIPageControl = {
        let page = UIPageControl()
        page.translatesAutoresizingMaskIntoConstraints = false
        return page
    }()
        
    let titleInMenu = ["Thông tin cá nhân", "Giáo viên chủ nhiệm", "Giáo viên bộ môn", "Đăng xuất"]
    
    var nameSubject = [Subject]()
//        ["Toán lớp 6", "Toán lớp 7", "Toán lớp 8", "Toán lớp 9"]
    
    var nameSubjectDictionary = [Int: Subject]()
    
    lazy var slideInMenuPadding: CGFloat = view.frame.width * 0.5
    
    var isSlideInMenuPresented = false
    
    var timer:Timer!
    
    let uid = Auth.auth().currentUser?.uid
    
    let database = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        fetchUserWithSubject()
                
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .done, target: self, action: #selector(tappedMenu))
        navigationItem.leftBarButtonItem = menuButton
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width + 100, height: view.bounds.height + 100)
        gradientLayer.colors = [#colorLiteral(red: 0.974270761, green: 0.9642215371, blue: 0.9773648381, alpha: 1).cgColor, #colorLiteral(red: 0.8661997318, green: 0.8461599946, blue: 0.8638817668, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        
        navigationItem.title = "Môn học"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.blueInLogo
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellowInLogo]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        menuView.pinMenuTo(self.view, with: slideInMenuPadding)
        containerView.edgeTo(self.view)
        
        menuView.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: menuView.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: menuView.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: menuView.trailingAnchor).isActive = true
        
        containerView.addSubview(collectionView)
//        containerView.addSubview(myPage)
        
        collectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor).isActive = true
        
//        myPage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//        myPage.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5).isActive = true
//        myPage.widthAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 0.5).isActive = true
//        myPage.heightAnchor.constraint(equalToConstant: 50).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.isPagingEnabled = true
        
        myPage.numberOfPages = nameSubject.count
        myPage.currentPage = 0
        myPage.currentPageIndicatorTintColor = .blue
    }
    
    @objc func tappedMenu() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSlideInMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
        } completion: { finished in
            self.isSlideInMenuPresented.toggle()
        }
    }
    
    func fetchUserWithSubject() {
        database.child("Users").child(uid!).observeSingleEvent(of: .value, with: { [self] snapshort in
            if let dictionary = snapshort.value as? [String: AnyObject] {
                var subject:Subject!
                switch dictionary["level"] as? String {
                case "Tiểu Học":
                    for i in 1...5 {
                        subject = Subject(dictionary: dictionary, i: i)
                        self.nameSubjectDictionary[i] = subject
                        self.attemptReloadOfCollection()
                    }
                case "Trung Học Cơ Sở":
                    for i in 6...9 {
                        subject = Subject(dictionary: dictionary, i: i)
                        self.nameSubjectDictionary[i] = subject
                        self.attemptReloadOfCollection()
                    }
                case "Trung Học Phổ Thông":
                    for i in 10...12 {
                        subject = Subject(dictionary: dictionary, i: i)
                        self.nameSubjectDictionary[i] = subject
                        self.attemptReloadOfCollection()
                    }
                default:
                    return
                }
            }
        }, withCancel: nil)
    }
    
    private func attemptReloadOfCollection() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadCollection() {
        self.nameSubject = Array(self.nameSubjectDictionary.values)
        
        self.nameSubject.sort { num1, num2 in
            return num1.num! < num2.num!
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = titleInMenu[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
//            let perInfoVC = UINavigationController(rootViewController: PerInforViewController())
//            perInfoVC.modalPresentationStyle = .fullScreen
//            self.present(perInfoVC, animated: true, completion: nil)
//            self.navigationController?.popToViewController(PerInforViewController(), animated: true)
            navigationController?.popViewController(animated: true)
        case 1:
            let tabBarC = UITabBarController()
            let contactVC = UINavigationController(rootViewController: ContactViewController())
            let messageVC = UINavigationController(rootViewController: MessageViewController())
            
            tabBarC.setViewControllers([contactVC, messageVC], animated: true)
            contactVC.title = "Danh bạ"
            contactVC.tabBarItem.image = UIImage(systemName: "person.crop.circle")
            contactVC.tabBarItem.badgeValue = "N+"
            messageVC.title = "Tin nhắn"
            messageVC.tabBarItem.image = UIImage(systemName: "message.fill")
            messageVC.tabBarItem.badgeValue = "N+"
            
            tabBarC.setViewControllers([contactVC, messageVC], animated: true)
            tabBarC.modalPresentationStyle = .fullScreen
            self.present(tabBarC, animated: true, completion: nil)
        case 2:
            break
        case 3:
            self.navigationController?.popToRootViewController(animated: true)
        default:
            break
        }
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameSubject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        let subject = nameSubject[indexPath.row]
        cell.subject = subject
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        myPage.currentPage = indexPath.row
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tabC = UITabBarController()
        let semester1 = SubjectSemester1()
        let semester2 = SubjectSemester2()
        let navigationSemester1 = UINavigationController(rootViewController: semester1)
        let navigationSemester2 = UINavigationController(rootViewController: semester2)
        tabC.setViewControllers([navigationSemester1, navigationSemester2], animated: true)
        semester1.title = "Học kì 1"
        navigationSemester1.tabBarItem.image = UIImage(systemName: "1.square.fill")
        semester2.title = "Học kỳ 2"
        navigationSemester2.tabBarItem.image = UIImage(systemName: "2.square.fill")
        let subject = nameSubject[indexPath.row]
        semester1.subject = subject
        semester2.subject = subject
        tabC.modalPresentationStyle = .fullScreen
        present(tabC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.bounds.height - 3 * 20) / CGFloat(nameSubject.count)
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
