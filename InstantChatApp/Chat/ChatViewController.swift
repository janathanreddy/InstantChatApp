//
//  ChatViewController.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
   

    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var chatimages: UIImageView!
    @IBOutlet weak var View_Chat_Name: UILabel!
    @IBOutlet weak var ChatTextField: UITextField!
    @IBOutlet weak var buttomconstrains: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()

    var ChatMessage = [messagedata]()
    var uid:String?
    var dateupdate: String?
    var timeupdate: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        TextField.delegate = self
        TextField.borderStyle = .none
        chatimages.layer.cornerRadius = 25
        chatimages.layer.masksToBounds = true
        print("UID : \(uid)")
        View_Chat_Name.text = UserDefaults.standard.value(forKey: "chatname") as? String
        ChatTextField.layer.cornerRadius = 13.0
        ChatTextField.layer.borderWidth = 1.0
        ChatTextField.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.delegate = self
        tableView.dataSource = self
        dataretrieve()
        tableView.rowHeight = UITableView.automaticDimension
        let tapRecognizer = UITapGestureRecognizer()
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.register(UINib(nibName: "ReceiverTableViewCell", bundle: nil), forCellReuseIdentifier: "receivercell")
    }
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    @objc func keyBoardWillShow(notification: Notification){
        if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>{
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            let keyBoardRect = frame?.cgRectValue
            if let keyBoardHeight = keyBoardRect?.height {
                self.buttomconstrains.constant = keyBoardHeight
                var contentInset:UIEdgeInsets = self.tableView.contentInset
                self.tableView.contentInset = contentInset
                tableView.scrollToRow(at: IndexPath(row: ChatMessage.count - 1 , section: 0), at: .top, animated: true)
                contentInset.bottom = keyBoardRect!.height
                _ = NSIndexPath(row: ChatMessage.count - 1, section: 0)
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            tableView.scrollToRow(at: IndexPath(row: ChatMessage.count - 1 , section: 0), at: .top, animated: true)
        }
    }
    @objc func keyBoardWillHide(notification: Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = contentInset
        self.buttomconstrains.constant = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    func date(){
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        dateupdate = formatter.string(from: currentDateTime)
        
    }
    func time(){
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        timeupdate = formatter.string(from: currentDateTime)
 
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatMessage.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if ChatMessage[indexPath.row].isFirstUser == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sendercell", for: indexPath) as! SenderTableViewCell
            cell.ChatTextLabel.text = ChatMessage[indexPath.row].text
            print("isFirstUser == true \(ChatMessage[indexPath.row].text)")
            cell.TimeLabel.text = ChatMessage[indexPath.row].time
            cell.ChatView.layer.cornerRadius = 16
           

            return cell
        }else if ChatMessage[indexPath.row].isFirstUser == false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "receivercell", for: indexPath) as! ReceiverTableViewCell
            cell.ReceiverText.text = ChatMessage[indexPath.row].text
            cell.ReceTime.text = ChatMessage[indexPath.row].time
            print("isFirstUser == false \(ChatMessage[indexPath.row].text)")
            cell.ReceiverView.layer.cornerRadius = 16
            
             return cell
        }
        return UITableViewCell()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let topRow = IndexPath(row: ChatMessage.count - 1,section: 0)
      self.tableView.scrollToRow(at: topRow, at: .top,animated: true)
           
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let topRow = IndexPath(row: ChatMessage.count - 1,section: 0)
      self.tableView.scrollToRow(at: topRow, at: .top,animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        date()
        time()
        let textFromField:String = TextField.text!
        if TextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "", message: "Message TextField Empty", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
            TextField.resignFirstResponder()
        }
        else{
            db.collection("chat_users").addDocument(data: ["uid":UserDefaults.standard.value(forKey: "senderuid") as? String,"message":textFromField,"datetime":FieldValue.serverTimestamp()])
            let topRow = IndexPath(row: ChatMessage.count - 1,section: 0)
          self.tableView.scrollToRow(at: topRow, at: .top,animated: true)
            tableView.reloadData()
            TextField.text = ""
            
        }
       return true
    }
    func dataretrieve(){
        self.db.collection("chat_users").order(by: "datetime").addSnapshotListener{ [self] (snapshot, err) in
            ChatMessage.removeAll()

              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  for document in snapshot!.documents {
                    let documentData = document.data()
                    print("documentData \(documentData)")
                    guard let time_Stamp = documentData["datetime"] as? Timestamp else { return }
                    let timeStamp = time_Stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.amSymbol = "AM"
                    dateFormatter.pmSymbol = "PM"
                    dateFormatter.dateFormat = "hh:mm a"
                    let ChatTime = dateFormatter.string(from: timeStamp)
                    if documentData["uid"] as? String == UserDefaults.standard.value(forKey: "uid") as? String{
                     
                        ChatMessage.append(messagedata(text: documentData["message"] as? String ?? "", time: "\(ChatTime)", isFirstUser: false, uid: documentData["uid"] as? String ?? ""))

                        print("dataretrieve false: \(ChatMessage)")
                    }else{
                        

                        ChatMessage.append(messagedata(text: documentData["message"] as? String ?? "", time: "\(ChatTime)", isFirstUser: true, uid: UserDefaults.standard.value(forKey: "senderuid") as? String ?? ""))

                    }
                    
                    print("dataretrieve true: \(ChatMessage)")

                  }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
              }
        }
    }
}

struct messagedata {
    
    var text : String
    var time : String
    var isFirstUser : Bool
    var uid:String
    
}
