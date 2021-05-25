//
//  ViewController.swift
//  YUAS
//
//  Created by Hakan Tunç on 28.11.2020.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        print ("This phones uniqe ID is: " + UIDevice.current.identifierForVendor!.uuidString)
        StudentsData.StudentsUniquePhoneIDs = UIDevice.current.identifierForVendor!.uuidString
        print("Login session begun..")
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture) //Closing keyboard when tapped to screen
    }

    @IBAction func loginButton(_ sender: Any) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        let usernameText: String = usernameField.text!
        let passwordText: String = passwordField.text!
        if ((loginCheck(username: usernameText,password: passwordText)) != "0") {
            StudentsData.StudentsNamesandSurnamesText = loginCheck(username: usernameText,password: passwordText)
            /*if (StudentsData.StudentsUniquePhoneIDs == UIDevice.current.identifierForVendor!.uuidString && StudentsData.StudentsNamesandSurnamesText != StudentsData.StudentsPhoneIDTextVerification){
                let alert1 = UIAlertController(title: "Phone Cheat", message: "This phone is registered for another user already. Please your own phone to login", preferredStyle: .alert)
                alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert1, animated: true)
                return
            }*/
            print("Logged in..")
            guard let vc = storyboard?.instantiateViewController(identifier: "operationVC") as? OperationViewController else{
                return
            }
            present(vc, animated: true)
        }
        else if (usernameText == "admin" && passwordText == "admin") {
            StudentsData.StudentsNamesandSurnamesText = "admin"
            print("Logged in..")
            guard let vc = storyboard?.instantiateViewController(identifier: "teacherVC") as? TeacherViewController else{
                return
            }
            present(vc, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Confirmation", message: "Wrong username or password, please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("Unsuccesful Login Attempt")
        }

    }
    /*@IBAction func signUpButton(_ sender: Any) {
        guard let vc2 = storyboard?.instantiateViewController(identifier: "signUpVC") as? SignUpViewController else{
            return
        }
        present(vc2, animated: true)
    }*/

    
}


extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
}

func loginCheck(username: String, password: String) -> String{
    let count = StudentsData.StudentsUsernames.count
    for index in 0..<count {
        if (username == StudentsData.StudentsUsernames[index] && password == StudentsData.StudentsPasswords[index] ){
            return StudentsData.StudentsNamesandSurnames[index]
        }
    }
    return "0"
}

struct StudentsData {
    static var StudentsUsernames = ["hakantunc","student1","student2",]
    static var StudentsPasswords = ["123","1234","12345"]
    static var StudentsNamesandSurnames = ["Hakan Tunç","Bahadır Bağ","Özgür Eker"]
    static var StudentsNamesandSurnamesText = ""
    static var StudentsIDs = [""]
    static var StudentsUniquePhoneIDs = ""
    static var StudentsPhoneIDTextVerification = "Hakan Tunç"
}

