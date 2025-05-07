//
//  PrivacyPolicy.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 15/10/24.
//

import UIKit

class PrivacyPolicy:UIViewController{
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title1.layer.shadowColor = UIColor.darkGray.cgColor
        title1.layer.shadowOpacity = 0.5
        title1.layer.shadowOffset.width = .zero
        title1.layer.shadowOffset.height = 4
        
        title2.layer.shadowColor = UIColor.darkGray.cgColor
        title2.layer.shadowOpacity = 0.5
        title2.layer.shadowOffset.width = .zero
        title2.layer.shadowOffset.height = 4
        
        
    }
}
