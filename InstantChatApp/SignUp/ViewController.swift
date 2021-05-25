//
//  ViewController.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var SignUpView: UIView!
    @IBOutlet weak var SignupBtn: UIButton!
    @IBOutlet weak var DepartmentText: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var EmailIdText: UITextField!
    @IBOutlet weak var MobileText: UITextField!
    @IBOutlet weak var AgeText: UITextField!
    @IBOutlet weak var NameText: UITextField!
    var validation = Validation()

    override func viewDidLoad() {
        super.viewDidLoad()
        HideKeyboard()
        ViewShawdow()
        EmailIdText.delegate = self
        MobileText.delegate = self
        AgeText.delegate = self
        NameText.delegate = self
        Password.delegate = self
        DepartmentText.delegate = self
        SignupBtn.layer.cornerRadius = 10
        SignupBtn.layer.masksToBounds = true
        NameText.tag = 0
        AgeText.tag = 1
        DepartmentText.tag = 2
        MobileText.tag = 3
        EmailIdText.tag = 4
        Password.tag = 5
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == NameText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 19), animated: true)
        }else if textField == AgeText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 38), animated: true)
        }else if textField == DepartmentText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 57), animated: true)
        }else if textField == MobileText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 76), animated: true)
        }else if textField == EmailIdText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 95), animated: true)
        }else if textField == Password{
            scrolView.setContentOffset(CGPoint(x: 0, y: 114), animated: true)
        }
        
    }

    func ViewShawdow(){
        // corner radius
        SignUpView.layer.cornerRadius = 3

        // border
        SignUpView.layer.borderWidth = 1.0
        SignUpView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        SignUpView.layer.shadowColor = UIColor.black.cgColor
        SignUpView.layer.shadowOffset = CGSize(width: 3, height: 3)
        SignUpView.layer.shadowOpacity = 0.7
        SignUpView.layer.shadowRadius = 4.0

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            var point = SignUpView.frame.origin
            point.y = 8
            point.x = 0
            scrolView.setContentOffset(point, animated: true)
            nextField.becomeFirstResponder()
        } else {
           textField.resignFirstResponder()
            DismissKeyboard()
        }
        return false
      }
    
    func HideKeyboard() {
      let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector(DismissKeyboard))
      view.addGestureRecognizer(Tap)
    }
    @objc func DismissKeyboard(){
    var point = SignUpView.frame.origin
    point.y = 0
    point.x = 0
    scrolView.setContentOffset(point, animated: true)
    view.endEditing(true)
    }
    @IBAction func SignupAction(_ sender: Any) {
        DismissKeyboard()
        let password = Password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let mobileno = MobileText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Name = NameText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Age = AgeText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let EmailId = EmailIdText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let Department = DepartmentText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if mobileno.isEmpty == true || password.isEmpty == true || Name.isEmpty == true || Age.isEmpty == true || EmailId.isEmpty == true || Department.isEmpty == true{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Fill All Fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        }
        
        else if mobileno.count < 10 || mobileno.count > 10{
          print("Enter Your 10 Digits Mobile Number")
            
            let alertController = UIAlertController(title: "Alert", message:
                "Check Your Mobile Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)

        }

        else if validation.validatePassword(password: password)==false{
            let alertController = UIAlertController(title: "Alert", message:
                "Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number")
        }
        else{
            performSegue(withIdentifier: "SignUPToLogin", sender: self)
        }
print("tapped")
        
    }
    
}

