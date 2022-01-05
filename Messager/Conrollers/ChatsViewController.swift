//
//  ChatsViewController.swift
//  Messager
//
//  Created by Сергей on 24.12.2021.
//

import Foundation
import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore

class ChatsViewController: MessagesViewController {

    // variables
    private var messageListener: ListenerRegistration?
    private var messages: [Message] = []
    private let user: MessageUser
    private let chat: MessageChat
    
    init(user: MessageUser, chat: MessageChat) {
        self.user = user
        self.chat = chat
        super.init(nibName: nil, bundle: nil)
        self.title = chat.friendUsername
    }
    
    deinit {
        messageListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        configureMessageInputBar()
        messagesCollectionView.backgroundColor = .white
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageListener = ListenerService.shared.messagesObserve(chat: chat, completion: { result in
            switch result {
            case .success(var message):
                if let url = message.downloadURL {
                    StorageServices.shared.downloadImage(url: url) { [weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success(let image):
                            message.image = image
                            self.insertNewMessage(message: message)
                        case .failure(let error):
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                } else {
                    self.insertNewMessage(message: message)
                }
                
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    private func insertNewMessage(message: Message) {
        guard !messages.contains(message) else {return}
        messages.append(message)
        messages.sort()
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: true)
            }
            
        }
    }
    
    
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.inputTextView.backgroundColor = .white
        messageInputBar.inputTextView.placeholderTextColor = .gray
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = CGColor.init(gray: 0.1, alpha: 0)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        messageInputBar.layer.shadowColor = CGColor(gray: 1, alpha: 0)
        messageInputBar.layer.shadowRadius = 5
        messageInputBar.layer.shadowOpacity = 0.3
        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureCameraIcon()
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "Sent"), for: .normal)
        messageInputBar.setRightStackViewWidthConstant(to: 56, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 30)
        messageInputBar.sendButton.setSize(CGSize(width: 48, height: 48), animated: false)
        messageInputBar.middleContentViewPadding.right = -38
    }
    func configureCameraIcon() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .magenta
        let cameraImage = UIImage(systemName: "camera")
        cameraItem.image = cameraImage
        
        cameraItem.addTarget(self, action: #selector(cameraButtonPressed), for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
    }
    
    private func sendPhoto(image: UIImage) {
        StorageServices.shared.uploadPhotoMessage(photo: image, to: chat) { result in
            switch result {
            case .success(let url):
                var message = Message(user: self.user, image: image)
                message.downloadURL = url
                FirestoreService.shared.sentMessage(chat: self.chat, message: message) { result in
                    switch result {
                    case .success():
                        self.messagesCollectionView.scrollToLastItem()
                    case .failure(let error):
                        self.showAlert(title: "Ошибка", message: "Изображение не доставлено")
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Error!", message: error.localizedDescription)
            }
        }
    }
    
}


extension ChatsViewController: MessagesDataSource {
    
    // Вводим наши данные
    func currentSender() -> SenderType {
        //        return user as! SenderType
        //        return mySender(senderId: user.id, displayName: user.username)
        return Sender(senderId: user.id, displayName: user.username)
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 8 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.brown])
        } else {
            return nil
        }
        
    }
    
    
}


extension ChatsViewController: MessagesLayoutDelegate {
    
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.item % 8 == 0 {
            return 30
        } else {
            return 0
        }
    }
    
}

extension ChatsViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .yellow : .magenta
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .brown : .blue
    }
    
    //    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    //
    //    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
}


extension ChatsViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: user, content: text)
        FirestoreService.shared.sentMessage(chat: chat, message: message) { result in
            switch result {
            case .success():
                self.messagesCollectionView.scrollToLastItem()
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
        inputBar.inputTextView.text = ""
    }
    
}

extension UIScrollView {
    
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}

extension ChatsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        sendPhoto(image: image)
    }
}
