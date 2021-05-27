//
//  LoginViewController.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController,UITextFieldDelegate {
    var window: UIWindow?
    @IBOutlet weak var LoginView: UIView!
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var PasswordText: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    var validation = Validation()
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewShawdow()
        EmailText.delegate = self
        PasswordText.delegate = self
        EmailText.tag = 0
        PasswordText.tag = 1
        LoginButton.layer.cornerRadius = 10
        LoginButton.layer.masksToBounds = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == EmailText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 20), animated: true)
        }else if textField == PasswordText{
            scrolView.setContentOffset(CGPoint(x: 0, y: 40), animated: true)
        }
        
    }
    func ViewShawdow(){
        // corner radius
        LoginView.layer.cornerRadius = 3

        // border
        LoginView.layer.borderWidth = 1.0
        LoginView.layer.borderColor = UIColor.lightGray.cgColor

        // shadow
        LoginView.layer.shadowColor = UIColor.black.cgColor
        LoginView.layer.shadowOffset = CGSize(width: 3, height: 3)
        LoginView.layer.shadowOpacity = 0.7
        LoginView.layer.shadowRadius = 4.0

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            var point = LoginView.frame.origin
            point.y = 20
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
    var point = LoginView.frame.origin
    point.y = 0
    point.x = 0
    scrolView.setContentOffset(point, animated: true)
    view.endEditing(true)
    }
    
    @IBAction func SignInAction(_ sender: Any) {
        DismissKeyboard()
        
        let EmailId = EmailText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = PasswordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if password.isEmpty == true || EmailId.isEmpty == true{
            
            let alertController = UIAlertController(title: "Alert", message:
                "Fill All Fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        } else if validation.validatePassword(password: password)==false{
            let alertController = UIAlertController(title: "Alert", message:
                "Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
            print("Please Make Sure Your Password is at least 8 Characters, Contains a Special Character and a Number")
        }
        else{
            Auth.auth().signIn(withEmail: EmailId, password: password) { (result, error) in
                
                if error != nil {
                    // Couldn't sign in
                    let alertController = UIAlertController(title: "Alert", message:
                        "Couldn't sign in", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                    self.present(alertController, animated: true, completion: nil)
                }
                else {
                    UserDefaults.standard.setValue(EmailId, forKey: "email")
                    self.performSegue(withIdentifier: "LogintoHome", sender: self)

                }
            }
        }
        
        
    }
    
    
}
