//
//  ChatLogController.swift
//  ElectronicLessonPlans
//
//  Created by Chu Du on 10/08/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ChatLogController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let InputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        return button
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Tin nhắn văn bản"
        tf.adjustsFontSizeToFitWidth = true
        tf.borderStyle = .roundedRect
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    let uploadImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "photo.on.rectangle.angled")
        image.contentMode = .scaleAspectFit
        image.tintColor = .blueInLogo
        image.alpha = 0.6
        return image
    }()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    let cellId = "cellId"
    
    var inputViewBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
//        self.tabBarController?.tabBar.isHidden = true
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .interactive
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        inputTextField.delegate = self
        
        uploadImage.isUserInteractionEnabled = true
        uploadImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        
//        setupKeyboardObservers()
    }
    
    func setupLayout() {
        self.view.overrideUserInterfaceStyle = .light
        
        self.view.addSubview(containerView)
        containerView.addSubview(collectionView)
        containerView.addSubview(InputView)
        InputView.addSubview(sendButton)
        InputView.addSubview(inputTextField)
        InputView.addSubview(uploadImage)
        
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        InputView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        inputViewBottomAnchor = InputView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor)
        inputViewBottomAnchor?.isActive = true
        
        InputView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        InputView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: InputView.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        sendButton.trailingAnchor.constraint(equalTo: InputView.trailingAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: InputView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 27).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        uploadImage.leadingAnchor.constraint(equalTo: InputView.leadingAnchor, constant: 13).isActive = true
        uploadImage.centerYAnchor.constraint(equalTo: InputView.centerYAnchor).isActive = true
        uploadImage.widthAnchor.constraint(equalToConstant: 35).isActive = true
        uploadImage.heightAnchor.constraint(equalToConstant: 27).isActive = true
        
        inputTextField.centerYAnchor.constraint(equalTo: InputView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 37).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: uploadImage.trailingAnchor, constant: 10).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
                
        separatorLineView(subView: InputView)
        
        inputTextField.layer.cornerRadius = 37/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = FirebaseDatabase.Database.database().reference().child("User-Messages").child(fromId).child(toId)
            let messageId = childRef.key
            let dic = [messageId: 1]
            userMessagesRef.updateChildValues(dic)
            
            let recipientUserMessagesRef = FirebaseDatabase.Database.database().reference().child("User-Messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues(dic)
        }
        
        inputTextField.text = ""
    }
    
    func separatorLineView(subView: UIView) {
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = #colorLiteral(red: 0.05545127392, green: 0.2396655977, blue: 0.383887887, alpha: 1)
        self.view.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            underlineView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: subView.topAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else { return }
        let userMessagesRef = Database.database().reference().child("User-Messages").child(uid).child(toId)
        
        userMessagesRef.observe(.childAdded, with: { snapshort in
            
            let messageId = snapshort.key
            let messageRef = Database.database().reference().child("Messages").child(messageId)
            
            messageRef.observeSingleEvent(of: .value, with: { snapshort in
                
                guard let dictionay = snapshort.value as? [String: AnyObject] else { return }
                                
                self.messages.append(Message(dictionary: dictionay))
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: ChatLogController.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: ChatLogController.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: ChatLogController.keyboardWillHideNotification , object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[ChatLogController.keyboardFrameEndUserInfoKey] as! NSValue)
            .cgRectValue
        let keyboardDuration = (notification.userInfo?[ChatLogController.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        inputViewBottomAnchor?.constant = -keyboardFrame.height
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        inputViewBottomAnchor?.constant = 0
        
        let keyboardDuration = (notification.userInfo?[ChatLogController.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleUploadTap() {
        presentPhotoActionSheet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

extension ChatLogController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        
        setupCell(cell: cell, message: message)
        
        cell.textView.text = message.text
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        } else if message.imageURL != nil {
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options , attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageURL = self.user?.profileImageURL {
            cell.profileImage.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.bubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
            cell.textView.textColor = .white
            
            cell.bubbleLeadingAnchor?.isActive = false
            cell.bubbleTrailingAnchor?.isActive = true
            cell.profileImage.isHidden = true
        } else {
            cell.bubbleView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.92, alpha: 1.00)
            cell.textView.textColor = .black
            
            cell.bubbleTrailingAnchor?.isActive = false
            cell.bubbleLeadingAnchor?.isActive = true
            cell.profileImage.isHidden = false
        }
        
        if let messageImageURL = message.imageURL {
            cell.messageImage.loadImageUsingCacheWithUrlString(urlString: messageImageURL)
            cell.messageImage.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImage.isHidden = true
        }
    }
}

extension ChatLogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Ảnh", message: "Bạn muốn chọn ảnh từ thư viện hay chụp ảnh?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Chụp ảnh", style: .default, handler: { _ in
            self.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chọn ảnh", style: .default, handler: { _ in
            self.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else
        if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
//            print(selectedImage)
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("Message_Images").child(imageName)

        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { metadata, error in
                if error != nil {
                    return
                }

                ref.downloadURL { url, error in
                    if error != nil {
                        print(error!)
                        return
                    }

                    if let imageURL = url?.absoluteString {
//                        print(imageURL)
                        self.sendMessageWithImageURL(imageURL: imageURL, image: image)
                    }
                }
            }
        }
    }
    
    private func sendMessageWithImageURL(imageURL: String, image: UIImage) {
//        print(imageURL)
        let ref = FirebaseDatabase.Database.database().reference().child("Messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        let values = ["imageURL": imageURL, "toId": toId, "fromId": fromId, "timestamp": timestamp, "imageWidth": image.size.width, "imageHeight": image.size.height] as [String : Any]
                
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            let userMessagesRef = FirebaseDatabase.Database.database().reference().child("User-Messages").child(fromId).child(toId)
            let messageId = childRef.key
            let dic = [messageId: 1]
            userMessagesRef.updateChildValues(dic)
            
            let recipientUserMessagesRef = FirebaseDatabase.Database.database().reference().child("User-Messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues(dic)
        }
        
        inputTextField.text = ""
    }

}
