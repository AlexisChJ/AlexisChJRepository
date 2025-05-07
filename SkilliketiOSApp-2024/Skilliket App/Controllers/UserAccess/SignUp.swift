//
//  SignUp.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit

class SignUp: UIViewController, UITextViewDelegate {
    var myProfileVC: MyProfile?
    @IBOutlet weak var SignUpTitle: UILabel!
    @IBOutlet weak var ButtonBig: UIButton!
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var SelectGender: UIButton!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var UserAdminBar: UISegmentedControl!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var PrivacyNotice: UIButton!
    
    @IBOutlet weak var BackButton: UIImageView!
    @IBAction func BackButtonAction(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "SplashScreen") as? SplashScreen {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    @IBAction func SelectType(_ sender: Any) {
        
    }
    @IBAction func ButtonBigText(_ sender: Any) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        userAdminChanged()
        SignUpTitle.layer.shadowColor = UIColor.darkGray.cgColor
        SignUpTitle.layer.shadowOpacity = 0.5
        SignUpTitle.layer.shadowOffset.width = .zero
        SignUpTitle.layer.shadowOffset.height = 4
        Password.isSecureTextEntry = true
        ConfirmPassword.isSecureTextEntry = true
        FirstName.addLine(position: .bottom, color: .darkGray, width: 0.75)
        LastName.addLine(position: .bottom, color: .darkGray, width: 0.75)
        Age.addLine(position: .bottom, color: .darkGray, width: 0.75)
        Email.addLine(position: .bottom, color: .darkGray, width: 0.75)
        Password.addLine(position: .bottom, color: .darkGray, width: 0.75)
        ConfirmPassword.addLine(position: .bottom, color: .darkGray, width: 0.75)
        
        let maleAction = UIAction(title: "Male", handler: { _ in })
        let femaleAction = UIAction(title: "Female", handler: { _ in })
        let otherAction = UIAction(title: "Other", handler: { _ in })
        
        let genderMenu = UIMenu(title: "Select Gender", options: .displayInline, children: [maleAction, femaleAction, otherAction])
        
        SelectGender.menu = genderMenu
        SelectGender.showsMenuAsPrimaryAction = true
        ProgressBar.progress = 0.0
        ButtonBig.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        [FirstName, LastName, Age, Email, Password, ConfirmPassword].forEach { textField in
            textField?.addTarget(self, action: #selector(fieldsDidChange), for: .editingChanged)
        }
        UserAdminBar.addTarget(self, action: #selector(userAdminChanged), for: .valueChanged)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture2)
        
        
        
        BackButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BackButtonAction(_:)))
        BackButton.addGestureRecognizer(tapGesture)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfile") as? MyProfile
    }
    
    @objc func fieldsDidChange() {
        let fields = [FirstName, LastName, Age, Email, Password, ConfirmPassword]
        let filledFields = fields.filter { $0?.text?.isEmpty == false }.count
        let totalFields = fields.count
        let progress = Float(filledFields) / Float(totalFields)
        ProgressBar.progress = progress
    }
    
    @objc func userAdminChanged() {
        if UserAdminBar.selectedSegmentIndex == 0 {
            ButtonBig.setTitle("Sign Up", for: .normal)
        } else if UserAdminBar.selectedSegmentIndex == 1 {
            ButtonBig.setTitle("Continue", for: .normal)
        }
    }
    
    @objc func buttonAction() {
        guard let email = Email.text?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            showErrorAlert("Please enter a valid email.")
            return
        }
        guard let password = Password.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showErrorAlert("Please enter a valid password.")
            return
        }
        guard let firstname = FirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !firstname.isEmpty else {
            showErrorAlert("Please enter your first name.")
            return
        }
        guard let lastname = LastName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !lastname.isEmpty else {
            showErrorAlert("Please enter your last name.")
            return
        }
        guard let ageText = Age.text?.trimmingCharacters(in: .whitespacesAndNewlines), let age = Int(ageText), !ageText.isEmpty else {
            showErrorAlert("Please enter a valid age.")
            return
        }
        guard let gender = SelectGender.currentTitle, !gender.isEmpty else {
            showErrorAlert("Please select your gender.")
            return
        }
        guard Password.text == ConfirmPassword.text else {
            showErrorAlert("Passwords do not match.")
            return
        }
        guard isValidPassword(password) else {
            showErrorAlert("Password must be at least 8 characters long, contain at least one uppercase letter and one number.")
            return
        }
        
        let typeUser = UserAdminBar.selectedSegmentIndex
        let newUser = User(email: email, password: password, firstname: firstname, lastname: lastname, age: age, gender: gender, typeUser: typeUser, experience: nil, educationLevel: nil, projects: nil, links: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let myProfileVC = storyboard.instantiateViewController(withIdentifier: "MyProfile") as? MyProfile {
            UserSession.shared.user = newUser
        }
        
        if UserAdminBar.selectedSegmentIndex == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition = storyboard.instantiateViewController(withIdentifier: "Verification") as? Verification {
                transtition.modalPresentationStyle = .fullScreen
                self.present(transtition, animated: false, completion: nil)
            }
        } else if UserAdminBar.selectedSegmentIndex == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "AdminSignUp") as? AdminSignUp {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        }
        
        
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }

    
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}





