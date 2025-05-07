//
//  MyProjects.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 07/10/24.
//

import UIKit


class MyProjects: UITableViewController, UITabBarDelegate {

    @IBOutlet weak var MyProjectsTitle: UILabel!
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let tabItem1 = UITabBarItem(title: "", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        let tabItem2 = UITabBarItem(title: "", image: UIImage(systemName: "network"), tag: 1)
        let tabItem3 = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: 2)
        let tabItem4 = UITabBarItem(title: "", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
        let tabItem5 = UITabBarItem(title: "", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
        let tabItem6 = UITabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 5)
        tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
        tabBar.selectedItem = tabItem5
        return tabBar
    }()
    var projectsList = [Projects]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        setupTitleWithIcon()
        setupTabBar()
        tabBarController?.tabBar.isTranslucent = true
        Task {
            do {
                let welcome = try await WelcomeJSON2.fetchProjectsJSON()
                self.actualizarUI(p: welcome)
            } catch {
                print("Error fetching news: \(ProjectsJSONError.notConnected)")
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCellIdentifier")
    }
    func actualizarUI(p: Welcome2) {
        Task {
            self.projectsList = p.projects
            self.tableView.reloadData()
        }
    }
    func setupTitleWithIcon() {
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "square.3.layers.3d")?.withTintColor(.green3)
        attachment.bounds = CGRect(x: 0, y: -4, width: 44, height: 44)
        let attachmentString = NSAttributedString(attachment: attachment)
        let spaceString = NSAttributedString(string: "  ")
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 0, height: 3)
        
        let titleString = NSAttributedString(string: "My Projects", attributes: [
            .font: UIFont(name: "Hiragino Mincho ProN W6", size: 44) ?? UIFont.systemFont(ofSize: 44),
            .foregroundColor: UIColor.darkGray,
            .shadow: shadow
        ])
        
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(attachmentString)
        attributedTitle.append(spaceString)
        attributedTitle.append(titleString)
        MyProjectsTitle.attributedText = attributedTitle
        MyProjectsTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(MyProjectsTitle)
        
        NSLayoutConstraint.activate([
            MyProjectsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            MyProjectsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
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
            tabBar.selectedItem = tabItem4
        } else {
            let tabItem1 = UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
            let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
            let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem5 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
            tabBar.selectedItem = tabItem5
        }
        view.addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projectsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCellIdentifier", for: indexPath)
        
        let projects = projectsList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = projects.title
        content.secondaryText = projects.location
        
        content.textProperties.font = UIFont(name: "Helvetica Neue", size: 16) ?? UIFont.systemFont(ofSize: 16)
        content.textProperties.color = UIColor.green3
        content.textProperties.numberOfLines = 0
        content.textProperties.lineBreakMode = .byWordWrapping
        
        // Secondary text (date)
        content.secondaryTextProperties.font = UIFont(name: "Galvji", size: 14) ?? UIFont.systemFont(ofSize: 14)
        content.secondaryTextProperties.color = UIColor.green2
        
        if let imageURL = URL(string: projects.imageLink) {
            content.image = UIImage(systemName: "photo")
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        content.image = image
                        
                        if let imageView = cell.imageView {
                            imageView.contentMode = .scaleToFill
                            imageView.clipsToBounds = true
                        }
                        
                        cell.contentConfiguration = content
                    }
                } else {
                    print("Error loading image: \(String(describing: error))")
                }
            }.resume()
        } else {
            content.image = UIImage(systemName: "photo")
        }

        content.imageProperties.maximumSize = CGSize(width: 150, height: 100)
        content.imageProperties.reservedLayoutSize = CGSize(width: 150, height: 100)

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.yellow1.withAlphaComponent(0.5)
        cell.selectedBackgroundView = selectedBackgroundView

        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowProjectDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowProjectDetail" {
            if let destinationVC = segue.destination as? ProjectDetail,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedProjects = projectsList[indexPath.row]
                destinationVC.detail = selectedProjects
            }
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
