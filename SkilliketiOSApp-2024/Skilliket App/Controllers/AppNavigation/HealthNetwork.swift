//
//  HealthNetwork.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 12/10/24.
//

import UIKit
import SwiftUI

class HealthNetwork: UITableViewController, UITabBarDelegate {

    @IBOutlet weak var NetworkTitle: UILabel!
    var networkHealthData: [ResponsePT] = []


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
            let tabItem2 = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem3 = UITabBarItem(title: "", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem4 = UITabBarItem(title: "", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem5 = UITabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem2, tabItem3, tabItem4, tabItem5]
        } else {
            let tabItem1 = UITabBarItem(title: "", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
            let tabItem2 = UITabBarItem(title: "", image: UIImage(systemName: "network"), tag: 1)
            let tabItem3 = UITabBarItem(title: "", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem4 = UITabBarItem(title: "", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem5 = UITabBarItem(title: "", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem6 = UITabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 5)
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
    
    func setupTitleWithIcon() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "heart.text.square")?.withTintColor(.green3)
        attachment.bounds = CGRect(x: 0, y: -4, width: 44, height: 44)
        let attachmentString = NSAttributedString(attachment: attachment)
        let spaceString = NSAttributedString(string: "  ")
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 0, height: 3)
        
        let titleString = NSAttributedString(string: "Health", attributes: [
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        setupTabBar()
        setupTitleWithIcon()
        tabBarController?.tabBar.isTranslucent = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HealthCell")
                Task {
                    do {
                        let token = try await WelcomePT2.getToken2()
                        if let token = token {
                            let healthData = try await WelcomePT2.getHosts(token: token)
                            updateUI(with: healthData)
                        }
                    } catch {
                        displayError(WelcomePT2Error.HealthNotFound, title: "Error al recuperar la salud de la red")
                    }
                }
    }

    
    func updateUI(with data: [ResponsePT]) {
            DispatchQueue.main.async {
                self.networkHealthData = data
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

        return networkHealthData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthCell", for: indexPath)
                let response = networkHealthData[indexPath.row]
                var content = cell.defaultContentConfiguration()
        content.text = "Connected Clients: \(response.clients.totalPercentage)"
                content.secondaryText = "Total Devices: \(response.networkDevices.totalDevices), Healthy Percentage: \(response.networkDevices.totalPercentage)"
                cell.contentConfiguration = content
                return cell
    }
    
    // MARK: - Table view delegate methods

        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let networkDevice = networkHealthData[indexPath.row].networkDevices
            showNetworkDevicesDetail(networkDevices: networkDevice.networkDevices)
        }

        func showNetworkDevicesDetail(networkDevices: [NetworkDevice]) {
            var deviceDetails = ""
            for device in networkDevices {
                deviceDetails += "\(device.deviceType.rawValue): \(device.healthyRatio.rawValue), Healthy: \(device.healthyPercentage)%\n"
            }
            
            let alert = UIAlertController(title: "Network Devices Detail", message: deviceDetails, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
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
