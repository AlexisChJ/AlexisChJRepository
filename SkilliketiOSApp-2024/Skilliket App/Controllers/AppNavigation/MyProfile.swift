//
//  MyProfile.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 03/10/24.
//

import UIKit

class MyProfile: UIViewController, UITabBarDelegate, UITextViewDelegate {
    
    @IBOutlet weak var ProfileTitle2: UILabel!
    @IBOutlet weak var ProfileTitle: UILabel!
    @IBOutlet weak var Email: UILabel?
    @IBOutlet weak var LastName: UILabel?
    @IBOutlet weak var Age: UILabel?
    @IBOutlet weak var Gender: UILabel?
    @IBOutlet weak var EditProfile: UIButton!
    @IBOutlet weak var ProfilePhoto: UIImageView!
    @IBOutlet weak var FirstName: UILabel?
    @IBOutlet weak var LogOut: UIButton!
    var CreateAccountButton: UIButton!
    @IBAction func ButtonEditProfile(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "LogIn") as? LogIn {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    var user: User?
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let tabItem1 = UITabBarItem(title: "", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        let tabItem2 = UITabBarItem(title: "", image: UIImage(systemName: "network"), tag: 1)
        let tabItem3 = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: 2)
        let tabItem4 = UITabBarItem(title: "", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
        let tabItem5 = UITabBarItem(title: "", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
        let tabItem6 = UITabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 5)
        tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
        tabBar.selectedItem = tabItem4
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.delegate = self
        self.hideKeyboard()
        tabBarController?.tabBar.isTranslucent = true
        ProfileTitle.layer.shadowColor = UIColor.darkGray.cgColor
        ProfileTitle.layer.shadowOpacity = 0.5
        ProfileTitle.layer.shadowOffset.width = .zero
        ProfileTitle.layer.shadowOffset.height = 4
        
        ProfileTitle2.layer.shadowColor = UIColor.darkGray.cgColor
        ProfileTitle2.layer.shadowOpacity = 0.5
        ProfileTitle2.layer.shadowOffset.width = .zero
        ProfileTitle2.layer.shadowOffset.height = 4
        
        ProfilePhoto.makeRounded()
        setupTabBar()
        loadUserData()
        loadProfileImage()
        LogOut.isUserInteractionEnabled = true
        LogOut.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture2)
    }
    func setupTabBar() {
        tabBar.delegate = self
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .heavy)], for: .normal)
                item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .selected)
            }
        }
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        UITabBar.appearance().tintColor = UIColor(named: "Green3")
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOpacity = 0.5
        
        tabBar.items = []
        guard let userType = UserSession.shared.user?.typeUser else {
            print("Error: El tipo de usuario es nil.")
            return
            
        }

        switch userType {
        case 0:
            tabBar.items = [UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2),
                            UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3),
                            UITabBarItem(title: "Layers", image: UIImage(systemName: "square.3.layers.3d"), tag: 4),
                            UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)]
        case 1:
            tabBar.items = [UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0),
                            UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1),
                            UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2),
                            UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3),
                            UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4),
                            UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)]
        default:
            tabBar.items = [UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2),
                            UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3),
                            UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)]
        }

        tabBar.selectedItem = tabBar.items?.last
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    
    @objc func createAccount() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let splashScreenViewController = storyboard.instantiateViewController(withIdentifier: "SplashScreen") as? SplashScreen {
            splashScreenViewController.modalPresentationStyle = .fullScreen
            self.present(splashScreenViewController, animated: true, completion: nil)
        }
    }
    
    @objc func logOut() {
        UserSession.shared.user = nil
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "SplashScreen") as? SplashScreen {
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func setupTitleWithIcon() {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "person.circle")
        attachment.bounds = CGRect(x: 0, y: -2, width: 40, height: 40)
        let attachmentString = NSAttributedString(attachment: attachment)
        let spaceString = NSAttributedString(string: "  ")
        let titleString = NSAttributedString(string: "My Profile", attributes: [.font: UIFont.systemFont(ofSize: 40)])
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(attachmentString)
        attributedTitle.append(spaceString)
        attributedTitle.append(titleString)
        ProfileTitle.attributedText = attributedTitle
        ProfileTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ProfileTitle)
        
        NSLayoutConstraint.activate([
            ProfileTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            ProfileTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func loadProfileImage() {
        guard let user = UserSession.shared.user else {
            return
        }
        
        var profileImageURL: String?
        
        if user.email == "user@tec.com" && user.password == "Password123"{
            profileImageURL = "https://img.freepik.com/free-photo/close-up-beautiful-woman-smiling_23-2148369437.jpg"
        } else if user.email == "admin@skiliket.com" && user.password == "Password123"{
            profileImageURL = "https://img.freepik.com/foto-gratis/chico-guapo-seguro-posando-contra-pared-blanca_176420-32936.jpg"
        } else {
            profileImageURL = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
        }
        if let imageURL = profileImageURL, let url = URL(string: imageURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self.ProfilePhoto.image = UIImage(data: data)
                    self.ProfilePhoto.contentMode = .scaleAspectFill
                    self.ProfilePhoto.layer.cornerRadius = self.ProfilePhoto.frame.size.width / 2
                    self.ProfilePhoto.layer.masksToBounds = true
                }
            }.resume()
        }
    }
    
    
    func loadUserData() {
        guard let user = UserSession.shared.user else {
            print("Error: El objeto 'user' es nil.")
            return
        }
        guard let firstNameField = FirstName,
              let lastNameField = LastName,
              let emailField = Email,
              let ageField = Age,
              let genderField = Gender else {
            print("Error: Uno o más IBOutlets no están conectados.")
            return
        }
        
        firstNameField.text = user.firstname
        lastNameField.text = user.lastname
        emailField.text = user.email
        ageField.text = "\(user.age)"
        genderField.text = user.gender
    }
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            print("w")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "CreateProject") as? CreateProject {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        case 1:
            print("w")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "Network") as? Network {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        case 2:
            print("w")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        case 3:
            print("w")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "Dashboard") as? Dashboard {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        case 4:
            print("w")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "MyProjects") as? MyProjects {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        case 5:
            print("w")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let transtition2 = storyboard.instantiateViewController(withIdentifier: "MyProfile") as? MyProfile {
                transtition2.modalPresentationStyle = .fullScreen
                self.present(transtition2, animated: false, completion: nil)
            }
        default:
            break
        }
    }
    
}
