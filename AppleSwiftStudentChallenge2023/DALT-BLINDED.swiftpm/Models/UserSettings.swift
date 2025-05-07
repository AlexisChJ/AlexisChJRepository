import Foundation
import Combine

class UserSettings: ObservableObject {
    //user name
    @Published var userName: String {
        didSet {
            UserDefaults.standard.set(userName, forKey: "UserName")
        }
    }
    //user colors
    @Published var userType: String {
        didSet {
            UserDefaults.standard.set(userType, forKey: "UserType")
        }
    }
    // list of colors
    public var userTypes = ["Select","Red","Orange","Green","Yellow","Blue","Purple","Brown","Pink"]
    
    
    //init method
    init() {
        self.userName = UserDefaults.standard.object(forKey: "UserName") as? String ?? ""
        self.userType = UserDefaults.standard.object(forKey: "UserType") as? String ?? "Select"
    }
}
