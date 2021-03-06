//
//  PerInforViewController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 15/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class PerInforViewController: UIViewController {
    
    let uid = Auth.auth().currentUser?.uid
    let database = Database.database().reference().child("Users")
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
        
    let levelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    let classView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    let subjectView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "H??? v?? T??n"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
    
    let dobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ng??y sinh"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()
            
    let levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "B???c gi???ng d???y"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = #colorLiteral(red: 0.9311701655, green: 0.9210054278, blue: 0.9385372996, alpha: 1)
        return label
    }()
    
    let levelTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let levelPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let classLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "L???p ch??? nhi???m"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = #colorLiteral(red: 0.9250538349, green: 0.9049116969, blue: 0.9270032048, alpha: 1)
        return label
    }()
    
    let classTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let classPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let subjectLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "M??n gi???ng d???y"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = #colorLiteral(red: 0.9124134183, green: 0.8973098993, blue: 0.9149338603, alpha: 1)
        return label
    }()
    
    let subjectTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    let subjectPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.crop.circle")
        image.tintColor = .lightGray
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        image.layer.masksToBounds = true
        return image
    }()
    
    let pickerLevel = ["Ti???u H???c", "Trung H???c C?? S???", "Trung H???c Ph??? Th??ng"]
    
    let pickerPrimaryNumber = ["_Ch???n l???p_", "1", "2", "3", "4", "5"]
    
    let pickerSecondaryNumber = ["_Ch???n l???p_", "6", "7", "8", "9"]
    
    let pickerHighSchoolNumber = ["_Ch???n l???p_", "10", "11", "12"]
    
    let kindOfNumber = ["", "A1", "A2", "A3", "A4", "A5", "A6"]
    
    let pickerPrimarySubject = ["To??n", "Ti???ng vi???t", "?????o ?????c", "M??? thu???t", "??m nh???c", "T??? nhi??n x?? h???i/Khoa h???c", "Ho???t ?????ng tr???i nghi???m", "Gi??o d???c th??? ch???t", "Tin h???c", "K??? thu???t", "L???ch s??? & ?????a l??"]
    
    let pickerSecondarySubject = ["To??n", "Ng??? V??n", "V???t l?? ", "Ho?? h???c", "Ti???ng Anh", "?????a l??", "L???ch s???", "C??ng ngh???", "??m nh???c & M??? thu???t", "Gi??o d???c c??ng d??n", "Sinh h???c"]
    
    let pickerHighSchoolSubject = ["?????i s??? & H??nh h???c", "Ng??? V??n", "V???t l??", "Ho?? h???c", "Gi??o d???c qu???c ph??ng", "L???ch s???", "?????a l??", "Gi??o d???c c??ng d??n", "Sinh h???c", "Gi??o d???c th??? ch???t", "Tin h???c"]
    
    var subjects = [String]()
            
    var isEdit: Bool = false
    
    var timer:Timer!
                        
    var levelLabelCenterYAnchor: NSLayoutConstraint?
    var classLabelCenterYAnchor: NSLayoutConstraint?
    var subjectLabelCenterYAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        
        navigationItem.rightBarButtonItem = self.editButtonItem
        editButtonItem.title = "S???a"
        editButtonItem.style = .done
        editButtonItem.action = #selector(onPressEdit)
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Th??ng tin c?? nh??n"
        navigationController?.navigationBar.isTranslucent = false
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .blueInLogo
        appearance.titleTextAttributes = [.foregroundColor: UIColor.yellowInLogo]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        checkUserAndFillInfor()
    }
    
    func setupLayout() {
        self.overrideUserInterfaceStyle = .light

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.974270761, green: 0.9642215371, blue: 0.9773648381, alpha: 1).cgColor, #colorLiteral(red: 0.8661997318, green: 0.8461599946, blue: 0.8638817668, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        containerView.layer.addSublayer(gradientLayer)
        
        containerView.edgeTo(view)
                
        containerView.addSubview(profileImage)
        containerView.addSubview(nameLabel)
        containerView.addSubview(dobLabel)
        containerView.addSubview(stackView)

        stackView.addArrangedSubview(levelView)
        stackView.addArrangedSubview(classView)
        stackView.addArrangedSubview(subjectView)
        
        containerView.addSubview(levelLabel)
        levelView.addSubview(levelTextField)
        
        containerView.addSubview(classLabel)
        classView.addSubview(classTextField)
        
        containerView.addSubview(subjectLabel)
        subjectView.addSubview(subjectTextField)
        
        profileImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        nameLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.9).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        dobLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        dobLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        dobLabel.widthAnchor.constraint(equalTo: nameLabel.widthAnchor).isActive = true
        dobLabel.heightAnchor.constraint(equalTo: nameLabel.heightAnchor).isActive = true
        
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 50).isActive = true
        stackView.widthAnchor.constraint(equalTo: dobLabel.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 220).isActive = true

        levelLabelCenterYAnchor = levelLabel.centerYAnchor.constraint(equalTo: levelView.centerYAnchor)
        levelLabelCenterYAnchor?.isActive = true
        levelLabel.leadingAnchor.constraint(equalTo: levelView.leadingAnchor, constant: 30).isActive = true

        levelTextField.centerYAnchor.constraint(equalTo: levelView.centerYAnchor).isActive = true
        levelTextField.leadingAnchor.constraint(equalTo: levelView.leadingAnchor, constant: 30).isActive = true
        levelTextField.trailingAnchor.constraint(equalTo: levelView.trailingAnchor, constant: -30).isActive = true

        classLabelCenterYAnchor = classLabel.centerYAnchor.constraint(equalTo: classView.centerYAnchor)
        classLabelCenterYAnchor?.isActive = true
        classLabel.leadingAnchor.constraint(equalTo: classView.leadingAnchor, constant: 30).isActive = true
        
        classTextField.centerYAnchor.constraint(equalTo: classView.centerYAnchor).isActive = true
        classTextField.leadingAnchor.constraint(equalTo: classView.leadingAnchor, constant: 30).isActive = true
        classTextField.trailingAnchor.constraint(equalTo: classView.trailingAnchor, constant: -30).isActive = true

        subjectLabelCenterYAnchor = subjectLabel.centerYAnchor.constraint(equalTo: subjectView.centerYAnchor)
        subjectLabelCenterYAnchor?.isActive = true
        subjectLabel.leadingAnchor.constraint(equalTo: subjectView.leadingAnchor, constant: 30).isActive = true
        
        subjectTextField.centerYAnchor.constraint(equalTo: subjectView.centerYAnchor).isActive = true
        subjectTextField.leadingAnchor.constraint(equalTo: subjectView.leadingAnchor, constant: 30).isActive = true
        subjectTextField.trailingAnchor.constraint(equalTo: subjectView.trailingAnchor, constant: -30).isActive = true
        
        levelTextField.inputView = levelPicker
        levelPicker.tag = 1
        levelPicker.delegate = self
        levelPicker.dataSource = self
        levelTextField.inputAccessoryView = createToolbar()
        
        classTextField.inputView = classPicker
        classPicker.tag = 2
        classPicker.delegate = self
        classPicker.dataSource = self
        classTextField.inputAccessoryView = createToolbar()
        
        subjectTextField.inputView = subjectPicker
        subjectPicker.tag = 3
        subjectPicker.delegate = self
        subjectPicker.dataSource = self
        subjectTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func onPressEdit() {
        isEditing.toggle()
        if isEditing {
            editButtonItem.title = "L??u"
            
            profileImage.isUserInteractionEnabled = true
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(slideTitle), userInfo: nil, repeats: false)
        } else {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("Profile_Image").child("\(imageName).png")

            if let uploadData = profileImage.image?.jpegData(compressionQuality: 0.2) {
                storageRef.putData(uploadData, metadata: nil) { metadata, error in
                    if error != nil {
                        return
                    }

                    storageRef.downloadURL {[self] url, error in
                        if error != nil {
                            print(error!)
                            return
                        }

                        guard let imageUrl = url?.absoluteString, let level = self.levelTextField.text, let nameClass = self.classTextField.text, let subject = subjectTextField.text else {
                            return
                        }
                        
                        let infor = ["profileImage": imageUrl, "level": level, "class": nameClass, "subject": subject]

                        self.uploadInformationWithUID(uid: self.uid!, values: infor)
                        
                    }
                }
            }
            
            profileImage.isUserInteractionEnabled = false
            
            if levelTextField.text == "" {
                levelTextField.text = "Kh??ng c??"
            }
            
            if classTextField.text == "" {
                classTextField.text = "Kh??ng c??"
            }
            
            if subjectTextField.text == "" {
                subjectTextField.text = "Kh??ng c??"
            }
            
            editButtonItem.title = "S???a"
            editButtonItem.style = .done
            
            levelTextField.isUserInteractionEnabled = false
            classTextField.isUserInteractionEnabled = false
            subjectTextField.isUserInteractionEnabled = false
        }
    }
        
    private func uploadInformationWithUID(uid: String, values: [String: String]) {
        database.child(uid).updateChildValues(values)
    }
    
    @objc func slideTitle() {
        levelTextField.isUserInteractionEnabled = true
        classTextField.isUserInteractionEnabled = true
        subjectTextField.isUserInteractionEnabled = true
        
        if levelTextField.text == "" {
            levelLabelCenterYAnchor?.constant = -(levelView.frame.height/2)
        }
        
        if classTextField.text == "" {
            classLabelCenterYAnchor?.constant = -(classView.frame.height/2)
        }
        
        if subjectTextField.text == "" {
            subjectLabelCenterYAnchor?.constant = -(subjectView.frame.height/2)
        }
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(onPressDone))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc func onPressDone() {
        self.view.endEditing(true)
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func checkUserAndFillInfor() {
        database.child(uid!).observeSingleEvent(of: .value, with: { snapshort in
            if let dictionary = snapshort.value as? [String: Any] {
                self.nameLabel.text = dictionary["name"] as? String
                self.dobLabel.text = dictionary["dob"] as? String
                
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

                if dictionary["level"] as? String != nil && dictionary["level"] as? String != "Kh??ng c??" {
                    self.levelLabelCenterYAnchor?.constant = -(self.levelView.frame.height/2)
                    self.levelTextField.text = dictionary["level"] as? String
                }

                if dictionary["class"] as? String != nil && dictionary["class"] as? String != "Kh??ng c??" {
                    self.classLabelCenterYAnchor?.constant = -(self.classView.frame.height/2)
                    self.classTextField.text = dictionary["class"] as? String
                }
                
                if dictionary["subject"] as? String != nil && dictionary["subject"] as? String != "Kh??ng c??" {
                    self.subjectLabelCenterYAnchor?.constant = -(self.subjectView.frame.height/2)
                    self.subjectTextField.text = dictionary["subject"] as? String
                }
            }
        }, withCancel: nil)
    }
}

extension PerInforViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1, 3:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return pickerLevel.count
        case 2:
            switch component {
            case 0:
                switch levelTextField.text {
                case pickerLevel[0]:
                    return pickerPrimaryNumber.count
                case pickerLevel[1]:
                    return pickerSecondaryNumber.count
                case pickerLevel[2]:
                    return pickerHighSchoolNumber.count
                default:
                    return 0
                }
            case 1:
                switch levelTextField.text {
                case pickerLevel[0], pickerLevel[1], pickerLevel[2]:
                    return kindOfNumber.count
                default:
                    return 0
                }
            default:
                return 0
            }
        case 3:
            switch levelTextField.text {
            case pickerLevel[0]:
                return pickerPrimarySubject.count
            case pickerLevel[1]:
                return pickerSecondarySubject.count
            case pickerLevel[2]:
                return pickerHighSchoolSubject.count
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return pickerLevel[row]
        case 2:
            switch component {
            case 0:
                switch levelTextField.text {
                case pickerLevel[0]:
                    return pickerPrimaryNumber[row]
                case pickerLevel[1]:
                    return pickerSecondaryNumber[row]
                case pickerLevel[2]:
                    return pickerHighSchoolNumber[row]
                default:
                    return ""
                }
            case 1:
                return kindOfNumber[row]
            default:
                return ""
            }
        case 3:
            switch levelTextField.text {
            case pickerLevel[0]:
                return pickerPrimarySubject[row]
            case pickerLevel[1]:
                return pickerSecondarySubject[row]
            case pickerLevel[2]:
                return pickerHighSchoolSubject[row]
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            levelTextField.text = pickerLevel[row]
        case 2:
            let selectedNumber = pickerView.selectedRow(inComponent: 0)
            let selectedKind = pickerView.selectedRow(inComponent: 1)
            switch levelTextField.text {
            case pickerLevel[0]:
                classTextField.text = pickerPrimaryNumber[selectedNumber] + kindOfNumber[selectedKind]
            case pickerLevel[1]:
                classTextField.text = pickerSecondaryNumber[selectedNumber] + kindOfNumber[selectedKind]
            case pickerLevel[2]:
                classTextField.text = pickerHighSchoolNumber[selectedNumber] + kindOfNumber[selectedKind]
            default:
                return
            }
        case 3:
            switch levelTextField.text {
            case pickerLevel[0]:
                subjectTextField.text = pickerPrimarySubject[row]
            case pickerLevel[1]:
                subjectTextField.text = pickerSecondarySubject[row]
            case pickerLevel[2]:
                subjectTextField.text = pickerHighSchoolSubject[row]
            default:
                return
            }
        default:
            return
        }
    }
}

extension PerInforViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editeImage = info[.editedImage] {
            selectedImageFromPicker = editeImage as? UIImage
        } else if let originalImage = info[.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
//            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
        
        self.dismiss(animated: true, completion: nil )
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil )
    }
}
