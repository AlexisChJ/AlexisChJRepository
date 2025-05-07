//
//  OverallHealth.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 13/10/24.
//

import UIKit

class OverallHealth: UIViewController, UITabBarDelegate  {
    @IBOutlet weak var TitleOverallHealth: UILabel!
    @IBOutlet weak var TitleOverallHealth2: UILabel!
    @IBOutlet weak var Clients: UILabel!
    @IBOutlet weak var NumClients: UILabel!
    @IBOutlet weak var HealthyNetDevices: UILabel!
    @IBOutlet weak var NumNHealthyetDevices: UILabel!
    @IBOutlet weak var AppPolicies: UILabel!
    @IBOutlet weak var NumAppPolicies: UILabel!
    @IBOutlet weak var LicRout: UILabel!
    @IBOutlet weak var NumLicRout: UILabel!
    @IBOutlet weak var LicSwitches: UILabel!
    @IBOutlet weak var NumLicSwitches: UILabel!
    @IBOutlet weak var NetDevices: UILabel!
    @IBOutlet weak var NumNetDevices: UILabel!
    @IBOutlet weak var UnDev: UILabel!
    @IBOutlet weak var NumUnDev: UILabel!
    
    
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let tabItem1 = UITabBarItem(title: "Projects", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
        let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
        let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
        let tabItem5 = UITabBarItem(title: "Layers", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
        let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
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
        setupTabBar()
        
        TitleOverallHealth.layer.shadowColor = UIColor.darkGray.cgColor
        TitleOverallHealth.layer.shadowOpacity = 0.5
        TitleOverallHealth.layer.shadowOffset.width = .zero
        TitleOverallHealth.layer.shadowOffset.height = 4
        
        TitleOverallHealth2.layer.shadowColor = UIColor.darkGray.cgColor
        TitleOverallHealth2.layer.shadowOpacity = 0.5
        TitleOverallHealth2.layer.shadowOffset.width = .zero
        TitleOverallHealth2.layer.shadowOffset.height = 4

        Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { [weak self] timer in
                self?.updateOverallHealth()
            }
    }
    private func updateOverallHealth() {
        Task {
            do {
                let token = try await OverallHealthJSON.getToken()
                let healthData = try await OverallHealthJSON.getOverallHealth(token: token)
                
                Clients.text = "Clients %"
                NumClients.text = healthData.healthyClient
                HealthyNetDevices.text = "Healthy Network Devices %"
                NumNHealthyetDevices.text = healthData.healthyNetworkDevice
                AppPolicies.text = "Application Policies"
                NumAppPolicies.text = healthData.numApplicationPolicies
                LicRout.text = "Licensed Routers"
                NumLicRout.text = healthData.numLicensedRouters
                LicSwitches.text = "Licensed Switches"
                NumLicSwitches.text = healthData.numLicensedSwitches
                NetDevices.text = "Network Devices"
                NumNetDevices.text = healthData.numNetworkDevices
                UnDev.text = "Unreachable Devices"
                NumUnDev.text = healthData.numUnreachable
                
            } catch {
                print("Error al obtener los datos de Overall Health: \(error.localizedDescription)")
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
