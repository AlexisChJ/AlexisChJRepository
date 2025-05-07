//
//  MainScreen.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit
import SwiftUI

class NewsView: UITableViewController, UITabBarDelegate {
    
    @IBOutlet weak var NewsTitle: UILabel!
    var newsList = [News]()
    var filteredNewsList = [News]()
    let tabBar: UITabBar = {
        let tabBar = UITabBar()
        let tabItem1 = UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
        let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
        let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
        let tabItem5 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
        let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
        tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
        tabBar.selectedItem = tabItem2
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        
        setupTitleWithIcon()
        setupTabBar()
        tabBarController?.tabBar.isTranslucent = true
        Task {
            do {
                let welcome = try await WelcomeJSON.fetchNewsJSON()
                self.actualizarUI(n: welcome)
            } catch {
                print("Error fetching news: \(NewsJSONError.notNewsFound)")
            }
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsIdentifier")
    }
    
    func setupTitleWithIcon() {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "newspaper")?.withTintColor(.green3)
        attachment.bounds = CGRect(x: 0, y: -4, width: 44, height: 44)
        let attachmentString = NSAttributedString(attachment: attachment)
        let spaceString = NSAttributedString(string: "  ")
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.darkGray
        shadow.shadowBlurRadius = 4
        shadow.shadowOffset = CGSize(width: 0, height: 3)
        
        let titleString = NSAttributedString(string: "News", attributes: [
            .font: UIFont(name: "Hiragino Mincho ProN W6", size: 44) ?? UIFont.systemFont(ofSize: 44),
            .foregroundColor: UIColor.darkGray,
            .shadow: shadow
        ])
        
        let attributedTitle = NSMutableAttributedString()
        attributedTitle.append(attachmentString)
        attributedTitle.append(spaceString)
        attributedTitle.append(titleString)
        NewsTitle.attributedText = attributedTitle
        NewsTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(NewsTitle)
        
        NSLayoutConstraint.activate([
            NewsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            NewsTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
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
            let tabItem4 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem5 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem2, tabItem3, tabItem4, tabItem5]
            tabBar.selectedItem = tabItem2
        } else if userType == 1 {
            let tabItem1 = UITabBarItem(title: "Create", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
            let tabItem2 = UITabBarItem(title: "Network", image: UIImage(systemName: "network"), tag: 1)
            let tabItem3 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem4 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem5 = UITabBarItem(title: "Projects", image: UIImage(systemName: "square.3.layers.3d"), tag: 4)
            let tabItem6 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem1, tabItem2, tabItem3, tabItem4, tabItem5, tabItem6]
            tabBar.selectedItem = tabItem3
        }else{
            let tabItem2 = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 2)
            let tabItem3 = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "circle.dotted.circle"), tag: 3)
            let tabItem5 = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 5)
            tabBar.items = [tabItem2, tabItem3, tabItem5]
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
    
    func actualizarUI(n:Welcome){
        Task{
            self.newsList = n.news
            self.tableView.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                filteredNewsList = newsList
            } else {
                filteredNewsList = newsList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
            tableView.reloadData()
        }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsIdentifier", for: indexPath)
        let news = newsList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = news.name
        content.secondaryText = news.date
        
        // Customizing text attributes (e.g., font size, color)
        content.textProperties.font = UIFont(name: "Helvetica Neue", size: 16) ?? UIFont.systemFont(ofSize: 16)
        content.textProperties.color = UIColor.darkText
        content.textProperties.numberOfLines = 0
        content.textProperties.lineBreakMode = .byWordWrapping
        
        // Secondary text (date)
        content.secondaryTextProperties.font = UIFont(name: "Galvji", size: 14) ?? UIFont.systemFont(ofSize: 14)
        content.secondaryTextProperties.color = UIColor.gray
        
        if let imageURL = URL(string: news.imageLink) {
            content.image = UIImage(systemName: "photo")
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        content.image = image
                        
                        if let imageView = cell.imageView {
                            imageView.contentMode = .scaleAspectFill
                            imageView.clipsToBounds = true // Ensure image is clipped to bounds
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
        
        // Customizing image properties (e.g., size)
        content.imageProperties.maximumSize = CGSize(width: 150, height: 100)
        content.imageProperties.reservedLayoutSize = CGSize(width: 150, height: 100)

        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowNewsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewsDetail" {
            if let destinationVC = segue.destination as? NewsDetail,
               let indexPath = tableView.indexPathForSelectedRow {
                let selectedNews = newsList[indexPath.row]
                destinationVC.news = selectedNews
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
