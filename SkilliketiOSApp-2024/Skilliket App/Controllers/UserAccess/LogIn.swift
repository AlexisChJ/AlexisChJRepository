//
//  LogIn.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit

class LogIn: UIViewController, UITextFieldDelegate {
    //USUARIOS PREDEFINIDOS
    let predefinedUsers: [User] = [
        User(email: "user@tec.com", password: "Password123", firstname: "Juana", lastname: "Perez", age: 30, gender: "Female", typeUser: 0, experience: nil, educationLevel: nil, projects: nil, links: nil),
        User(email: "admin@skiliket.com", password: "Password123", firstname: "Juan", lastname: "Perez", age: 28, gender: "Male", typeUser: 1, experience: nil, educationLevel: nil, projects: nil, links: nil)
    ]
    var loggedInUser: User?
    @IBOutlet weak var BackButton: UIImageView!
    @IBOutlet weak var LoginTitle: UILabel!
    @IBOutlet weak var BackgroundCutout: UIView!
    @IBOutlet weak var ForgotPass: UIButton!
    @IBOutlet weak var LogIn: UIButton!
    @IBOutlet weak var ContinueAsGuest: UIButton!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBAction func BackButtonAction(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "SplashScreen") as? SplashScreen {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    @IBAction func ForgotPassButt(_ sender: Any) {
        
    }
    @IBAction func LogInButt(_ sender: Any) {
        guard let emailText = Email.text, let passwordText = Password.text else {
            return
        }
        if let user = validateUser(email: emailText, password: passwordText) {
            loggedInUser = user
            UserSession.shared.user = user
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition = storyboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView {
                transtition.modalPresentationStyle = .fullScreen
                self.present(transtition, animated: false, completion: nil)
            }
        } else {
            showAlert("Invalid credentials", message: "Please check your email and password.")
        }
    }
    
    func validateUser(email: String, password: String) -> User? {
        for user in predefinedUsers {
            if user.email == email && user.password == password {
                return user
            }
        }
        return nil
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @IBAction func ContinueButt(_ sender: Any) {
        let userGuest = User(email: "Not registered", password: "Not registered", firstname: "Not registered", lastname: "Not registered", age: 0, gender: "?", typeUser: 3, experience: nil, educationLevel: nil, projects: nil, links: nil)
        UserSession.shared.user = userGuest
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition2 = storyboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView {
            transtition2.modalPresentationStyle = .fullScreen
            self.present(transtition2, animated: false, completion: nil)
        }
    }
    
    @objc func textFieldsDidChange() {
        if let emailText = Email.text, !emailText.isEmpty,
           let passwordText = Password.text, !passwordText.isEmpty {
            LogIn.isEnabled = true
        } else {
            LogIn.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        BackgroundCutout.drawCustomShape()
        Password.isSecureTextEntry = true
        LoginTitle.layer.shadowColor = UIColor.darkGray.cgColor
        LoginTitle.layer.shadowOpacity = 0.5
        LoginTitle.layer.shadowOffset.width = .zero
        LoginTitle.layer.shadowOffset.height = 4
        
        Email.addLine(position: .bottom, color: .darkGray, width: 0.75)
        Password.addLine(position: .bottom, color: .darkGray, width: 0.75)
        
        Email.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        Password.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture2)
        Email.delegate = self
        Password.delegate = self
        
        
        LogIn.isEnabled = true
        Email.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        Password.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        BackButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BackButtonAction(_:)))
        BackButton.addGestureRecognizer(tapGesture)
    }
    
    
}
