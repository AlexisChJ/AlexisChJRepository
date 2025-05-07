//
//  ViewController.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit

class SplashScreen: UIViewController {
    
    @IBOutlet weak var Title1: UILabel!
    @IBOutlet weak var Title2: UILabel!
    @IBOutlet weak var SubtitleText: UILabel!
    @IBOutlet weak var LogIn: UIButton!
    @IBOutlet weak var SignUp: UIButton!
    
    @IBAction func LogInButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "LogIn") as? LogIn {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    @IBAction func SignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition2 = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignUp {
            transtition2.modalPresentationStyle = .fullScreen
            self.present(transtition2, animated: false, completion: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Title1.layer.shadowColor = UIColor.darkGray.cgColor
        Title1.layer.shadowOpacity = 0.5
        Title1.layer.shadowOffset.width = .zero
        Title1.layer.shadowOffset.height = 4
        
        Title2.layer.shadowColor = UIColor.darkGray.cgColor
        Title2.layer.shadowOpacity = 0.5
        Title2.layer.shadowOffset.width = .zero
        Title2.layer.shadowOffset.height = 4
        
        SubtitleText.layer.shadowColor = UIColor.darkGray.cgColor
        SubtitleText.layer.shadowOpacity = 0.5
        SubtitleText.layer.shadowOffset.width = .zero
        SubtitleText.layer.shadowOffset.height = 4
    }
}
