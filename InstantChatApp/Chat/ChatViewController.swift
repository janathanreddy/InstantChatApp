//
//  ChatViewController.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var View_Chat_Name: UILabel!
    @IBOutlet weak var ChatTextField: UITextField!
    @IBOutlet weak var buttomconstrains: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatTextField.layer.cornerRadius = 13.0
        ChatTextField.layer.borderWidth = 1.0
        ChatTextField.layer.borderColor = UIColor.systemGray5.cgColor
 
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tableView.register(UINib(nibName: "AdminTextTableViewCell", bundle: nil), forCellReuseIdentifier: "AdminTextTableViewCell")
    }
    

   
}
struct MessageDataAdmin {
    var text : String
    var time : String
    var isFirstUser : Bool
    var date:Date

}

extension Date {
    static func dateFromCustomString(customString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func reduceToMonthDayYear() -> Date {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        let year = calendar.component(.year, from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.date(from: "\(day)/\(month)/\(year)") ?? Date()
    }
}
