//
//  ChatPersonViewController.swift
//  InstantChatApp
//
//  Created by Admin Macappstudio on 25/05/21.
//

import UIKit
import Firebase
class ChatPersonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inagesprofile: UIImageView!
    @IBOutlet weak var PersonName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var name:String?
    var images:String?
    var senderuid:String?
    var Person = [Persons]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        chat_persons()
        inagesprofile.layer.cornerRadius = 18
        inagesprofile.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(Person[indexPath.row].uid, forKey: "uid")
        UserDefaults.standard.setValue(senderuid, forKey: "senderuid")
        UserDefaults.standard.setValue(Person[indexPath.row].name, forKey: "chatname")
        performSegue(withIdentifier: "persontochat", sender: self)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Person.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatPersonTableViewCell
        cell.ImageViews.image = UIImage(named: "\(Person[indexPath.row].temp_image!)")
        cell.ImageViews.layer.cornerRadius = 25
        cell.ImageViews.layer.masksToBounds = true
        cell.NameLabel.text = Person[indexPath.row].name
        return cell
    }
    
    @IBAction func Logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
            } catch let err {
                print(err)
        }
        
    }
    func chat_persons(){
        self.db.collection("users").addSnapshotListener{ [self] (snapshot, err) in
              if let err = err {
                  print("Error getting documents: \(err)")
              } else {
                  for document in snapshot!.documents {
                    let documentData = document.data()
                    print("documentData \(documentData)")
                    
                    if documentData["email"] as? String == UserDefaults.standard.value(forKey: "email") as? String{
                        name = documentData["name"] as? String
                        images = documentData["temp_image"] as? String ?? ""
                        senderuid = documentData["uid"] as? String ?? ""
                        print("images \(images)")
                    }else if documentData["email"] as? String != UserDefaults.standard.value(forKey: "email") as? String{
                        Person.append(Persons(department: documentData["department"] as? String ?? "", age: documentData["age"] as? String ?? "", email: documentData["email"] as? String ?? "", name: documentData["name"] as? String ?? "", uid: documentData["uid"] as? String ?? "", mobileno: documentData["mobileno"] as? String ?? "",temp_image: documentData["temp_image"] as? String ?? ""))
                    }
                  }
                DispatchQueue.main.async {
                    inagesprofile.image = UIImage(named: "\(images!)")
                    PersonName.text = name
                    tableView.reloadData()
                  }
              }
        }

}
}

struct Persons {
    var department:String?
    var age:String?
    var email:String?
    var name:String?
    var uid:String?
    var mobileno:String?
    var temp_image:String?
}
