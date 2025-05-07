//
//  ReadyToBegin.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit

class ReadyToBegin: UIViewController {

    @IBOutlet weak var TextBegin: UILabel!
    @IBOutlet weak var Anywhere: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextBegin.layer.shadowColor = UIColor.darkGray.cgColor
        TextBegin.layer.shadowOpacity = 0.5
        TextBegin.layer.shadowOffset.width = .zero
        TextBegin.layer.shadowOffset.height = 4
        
        Anywhere.layer.shadowColor = UIColor.darkGray.cgColor
        Anywhere.layer.shadowOpacity = 0.5
        Anywhere.layer.shadowOffset.width = .zero
        Anywhere.layer.shadowOffset.height = 4
        
        addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToDashboard))
            view.addGestureRecognizer(tapGesture)
        }
    
    @objc func navigateToDashboard() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let dashController = storyboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView {
                dashController.modalPresentationStyle = .fullScreen
                self.present(dashController, animated: false, completion: nil)
            }
        }
}
