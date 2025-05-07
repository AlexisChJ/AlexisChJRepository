//
//  Verification.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit

class Verification: UIViewController, UITextFieldDelegate {
    var sourceView: String?
    @IBOutlet weak var VerificationTitle: UILabel!
    @IBOutlet weak var Verify: UIButton!
    @IBOutlet weak var Resend: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var EnterCode: UITextField!
    @IBOutlet weak var TextVerification: UILabel!
    @IBOutlet weak var VerificationCodeText: UILabel!
    
    @IBAction func VerifyButt(_ sender: Any) {
        if let code = EnterCode.text {
            if code == "123456" {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let transtition = storyboard.instantiateViewController(withIdentifier: "ReadyToBegin") as? ReadyToBegin {
                    transtition.modalPresentationStyle = .fullScreen
                    self.present(transtition, animated: false, completion: nil)
                }
                
            } else {
                showErrorAlert("Please enter a valid verification code.")
            }
        }
    }
    @IBAction func ResendButt(_ sender: Any) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        VerificationTitle.layer.shadowColor = UIColor.darkGray.cgColor
        VerificationTitle.layer.shadowOpacity = 0.5
        VerificationTitle.layer.shadowOffset.width = .zero
        VerificationTitle.layer.shadowOffset.height = 4
        
        VerificationCodeText.layer.shadowColor = UIColor.darkGray.cgColor
        VerificationCodeText.layer.shadowOpacity = 0.5
        VerificationCodeText.layer.shadowOffset.width = .zero
        VerificationCodeText.layer.shadowOffset.height = 4
        
        Verify.isEnabled = true
        
        EnterCode.addLine(position: .bottom, color: .green3, width: 1.0)
        EnterCode.defaultTextAttributes.updateValue(15.0, forKey: NSAttributedString.Key.kern)
        EnterCode.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        BackButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BackButtonAction(_:)))
        BackButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func textFieldDidChange() {
        if let text = EnterCode.text, !text.isEmpty {
            Verify.isEnabled = true
        } else {
            Verify.isEnabled = true
        }
    }
    
    @IBAction func BackButtonAction (_ sender:Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignUp {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    
    func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
