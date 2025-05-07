//
//  CreateProject.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 03/10/24.
//

import UIKit

class CreateProject: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var Title1: UILabel!
    @IBOutlet weak var Title2: UILabel!
    @IBOutlet weak var TitleProject: UITextField!
    @IBOutlet weak var Area: UITextField!
    @IBOutlet weak var DescriptionTitle: UILabel!
    @IBOutlet weak var Imagetitle: UILabel!
    @IBOutlet weak var TextFieldDescription: UITextView!
    @IBOutlet weak var VariablesTitle: UILabel!
    @IBOutlet weak var variablesSelection: UIButton!
    @IBOutlet weak var UserTopicsTitle: UILabel!
    @IBOutlet weak var UserTopicsTextfield: UITextView!
    @IBOutlet weak var ButtonCreateProject: UIButton!
    
    @IBAction func ButtonCreateProjectAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "Dashboard") as? Dashboard {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    
    var selectedVariables = Set<String>()
    let allVariables = ["Temperature", "Atmospheric pressure", "Smoke sensor", "Wind sensor", "Humidity", "Movement sensor", "Noise sensor", "Water sensor"]
    
    let photoUploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemRed
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(photoUploadButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    func setupVariablesSelectionMenu() {
        var menuItems: [UIAction] = []
        
        for variable in allVariables {
            let action = UIAction(title: variable, state: selectedVariables.contains(variable) ? .on : .off) { action in
                if self.selectedVariables.contains(variable) {
                    self.selectedVariables.remove(variable)
                } else {
                    self.selectedVariables.insert(variable)
                }
                self.updateVariablesSelectionButtonTitle()
                self.setupVariablesSelectionMenu()
            }
            menuItems.append(action)
        }
        
        let menu = UIMenu(title: "Select Variables", options: .displayInline, children: menuItems)
        variablesSelection.menu = menu
        variablesSelection.showsMenuAsPrimaryAction = true
    }
    
    func updateVariablesSelectionButtonTitle() {
        if selectedVariables.isEmpty {
            variablesSelection.setTitle("Select Variables", for: .normal)
        } else {
            let selectedTitles = selectedVariables.joined(separator: ", ")
            variablesSelection.setTitle(selectedTitles, for: .normal)
        }
    }
    
    @objc func photoUploadButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let tabItem1 = UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
        let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
        let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
        let tabItem5 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
        let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
        tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
        tabBar.selectedItem = tabItem1
        return tabBar
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupTabBar() {
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .heavy)], for: .normal)
                item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)], for: .selected)
            }
        }
        tabBar.delegate = self
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowOpacity = 0.3
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        UITabBar.appearance().tintColor = UIColor(named: "Green3")
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 15
        tabBar.layer.shadowOpacity = 0.5

        tabBar.items = []
        guard let userType = UserSession.shared.user?.typeUser else {
            print("Error: El tipo de usuario es nil.")
            return
        }
        if userType == 0 {
            let tabItem2 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem3 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem4 = UITabBarItem(title: "Layers", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem5 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem2, tabItem3, tabItem4, tabItem5]
            tabBar.selectedItem = tabItem2
        } else {
            let tabItem1 = UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
            let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
            let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem5 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
            tabBar.selectedItem = tabItem1
        }

        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        setupVariablesSelectionMenu()
        
        Title1.layer.shadowColor = UIColor.darkGray.cgColor
        Title1.layer.shadowOpacity = 0.5
        Title1.layer.shadowOffset.width = .zero
        Title1.layer.shadowOffset.height = 4
        
        Title2.layer.shadowColor = UIColor.darkGray.cgColor
        Title2.layer.shadowOpacity = 0.5
        Title2.layer.shadowOffset.width = .zero
        Title2.layer.shadowOffset.height = 4
        
        TitleProject.addLine(position: .bottom, color: .darkGray, width: 0.75)
        Area.addLine(position: .bottom, color: .darkGray, width: 0.75)
        
        TextFieldDescription.delegate = self
        TextFieldDescription.layer.borderColor = UIColor.systemGray5.cgColor
        TextFieldDescription.layer.borderWidth = 0.8
        TextFieldDescription.layer.cornerRadius = 5
        
        UserTopicsTextfield.delegate = self
        UserTopicsTextfield.layer.borderColor = UIColor.systemGray5.cgColor
        UserTopicsTextfield.layer.borderWidth = 0.8
        UserTopicsTextfield.layer.cornerRadius = 5
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture2)
        view.addSubview(photoUploadButton)
        photoUploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoUploadButton.centerXAnchor.constraint(equalTo: ButtonCreateProject.centerXAnchor),
            photoUploadButton.topAnchor.constraint(equalTo: ButtonCreateProject.bottomAnchor, constant: -350)
        ])
        
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let _ = info[.originalImage] as? UIImage {
            photoUploadButton.setImage(UIImage(systemName: "photo.badge.checkmark"), for: .normal)
            photoUploadButton.tintColor = .systemGreen
        }
    }
    
    
    // MARK: - UITabBarDelegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            switch item.tag {
            case 0:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let transtition2 = storyboard.instantiateViewController(withIdentifier: "CreateProject") as? CreateProject {
                    transtition2.modalPresentationStyle = .fullScreen
                    self.present(transtition2, animated: false, completion: nil)
                }
            case 1:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let transtition2 = storyboard.instantiateViewController(withIdentifier: "Network") as? Network {
                    transtition2.modalPresentationStyle = .fullScreen
                    self.present(transtition2, animated: false, completion: nil)
                }
            case 2:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let transtition2 = storyboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView {
                    transtition2.modalPresentationStyle = .fullScreen
                    self.present(transtition2, animated: false, completion: nil)
                }
            case 3:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let transtition2 = storyboard.instantiateViewController(withIdentifier: "Dashboard") as? Dashboard {
                    transtition2.modalPresentationStyle = .fullScreen
                    self.present(transtition2, animated: false, completion: nil)
                }
            case 4:
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let transtition2 = storyboard.instantiateViewController(withIdentifier: "MyProjects") as? MyProjects {
                    transtition2.modalPresentationStyle = .fullScreen
                    self.present(transtition2, animated: false, completion: nil)
                }
            case 5:
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
