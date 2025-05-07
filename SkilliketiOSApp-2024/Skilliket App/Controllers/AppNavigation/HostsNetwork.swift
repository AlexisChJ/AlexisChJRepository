//
//  Network.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 11/10/24.
//

import UIKit

class HostsNetwork: UITableViewController, UITabBarDelegate {

    @IBOutlet weak var NetworkTitle: UILabel!
    var hosts:[Response] = []
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let tabItem1 = UITabBarItem(title: "", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        let tabItem2 = UITabBarItem(title: "", image: UIImage(systemName: "network"), tag: 1)
        let tabItem3 = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: 2)
        let tabItem4 = UITabBarItem(title: "", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
        let tabItem5 = UITabBarItem(title: "", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
        let tabItem6 = UITabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 5)
        tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
        tabBar.selectedItem = tabItem2
        return tabBar
    }()
    
    func setupTitleWithIcon() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "wifi.router.fill")?.withTintColor(.green3)
        attachment.bounds = CGRect(x: 0, y: -4, width: 44, height: 44)
        let attachmentString = NSAttributedString(attachment: attachment)
        let spaceString = NSAttributedString(string: "  ")
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 0, height: 3)
        
        let titleString = NSAttributedString(string: "Hosts", attributes: [
            .font: UIFont(name: "Hiragino Mincho ProN W6", size: 44) ?? UIFont.systemFont(ofSize: 44),
            .foregroundColor: UIColor.darkGray,
            .shadow: shadow
        ])
        
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(attachmentString)
        attributedTitle.append(spaceString)
        attributedTitle.append(titleString)
        NetworkTitle.attributedText = attributedTitle
        NetworkTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NetworkTitle)
        
        NSLayoutConstraint.activate([
            NetworkTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            NetworkTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
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
        } else {
            let tabItem1 = UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
            let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
            let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem5 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
            tabBar.selectedItem = tabItem2
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
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        setupTabBar()
        setupTitleWithIcon()
        tabBarController?.tabBar.isTranslucent = true
        Task {
            do {
                let tokenPTT = try await WelcomePT.getToken()
                let hostList = try await WelcomePT.getHosts(token: tokenPTT!)
                updateUI(with:hostList)
                
            } catch {
                displayError(WelcomePTError.HostsNotFound, title: "Error al recuperar los hosts")
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HostIdentifier")

    }
    
    func updateUI(with hosts:[Response]) {
        DispatchQueue.main.async {
            self.hosts = hosts
            self.tableView.reloadData()
       }
    }
    func displayError(_ error: Error, title: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return hosts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCellIdentifier", for: indexPath)
        
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
                            imageView.contentMode = .scaleAspectFill
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
        return cell*/
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostIdentifier", for: indexPath)

        let host = hosts[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(host.hostName) - \(host.connectedNetworkDeviceName)"
        content.secondaryText = host.hostIP
        
        content.textProperties.font = UIFont(name: "Helvetica Neue", size: 16) ?? UIFont.systemFont(ofSize: 16)
        content.textProperties.numberOfLines = 0
        content.textProperties.lineBreakMode = .byWordWrapping
        
        content.secondaryTextProperties.font = UIFont(name: "Galvji", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        if host.pingStatus == "SUCCESS"{
            content.textProperties.color = UIColor.green2
            content.secondaryTextProperties.color = UIColor.green2
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }
        else{
            content.textProperties.color = UIColor.red
            content.secondaryTextProperties.color = UIColor.red
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
        cell.contentConfiguration = content

        return cell
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
