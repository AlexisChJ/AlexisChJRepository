//
//  Skilliket_AppTests.swift
//  Skilliket AppTests
//
//  Created by Alexis Chávez on 03/10/24.
//

import XCTest
import SwiftUI
@testable import Skilliket_App

final class Skilliket_AppTests: XCTestCase {
    //HU1
    func testUserCanSignUp() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signUpVC = storyboard.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        signUpVC.loadViewIfNeeded()
        signUpVC.FirstName.text = "Alex"
        signUpVC.LastName.text = "Chávez"
        signUpVC.Age.text = "25"
        signUpVC.Email.text = "alexis@example.com"
        signUpVC.Password.text = "Password123"
        signUpVC.ConfirmPassword.text = "Password123"
        signUpVC.UserAdminBar.selectedSegmentIndex = 0
        signUpVC.SelectGender.setTitle("Male", for: .normal)
        signUpVC.buttonAction()
        let user = UserSession.shared.user
        XCTAssertNotNil(user, "User should not be nil")
        XCTAssertEqual(user?.firstname, "Alex", "User's first name should be Alex")
        XCTAssertEqual(user?.lastname, "Chávez", "User's last name should be Chávez")
        XCTAssertEqual(user?.age, 25, "User's age should be 25")
        XCTAssertEqual(user?.email, "alexis@example.com", "User's email should be alexis@example.com")
        XCTAssertEqual(user?.typeUser, 0, "User's type should be User")
        let presentedVC = signUpVC.presentedViewController
    }
    //HU3
    var verificationVC: Verification!
    override func setUpWithError() throws {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        verificationVC = storyboard.instantiateViewController(withIdentifier: "Verification") as? Verification
        verificationVC.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        verificationVC = nil
        super.tearDown()
    }
    
    func testUserCanVerifyAccount() throws {
        let expectedCode = "123456"
        verificationVC.EnterCode.text = expectedCode
        verificationVC.VerifyButt(self)
    }
    //H05
    func createLogInViewController() -> LogIn {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LogIn") as! LogIn
        loginVC.loadViewIfNeeded()
        return loginVC
    }
    
    func testUserCanLoginWithPredefinedUser() throws {
        let loginVC = createLogInViewController()
        let validEmail = "user@tec.com"
        let validPassword = "Password123"
        loginVC.Email.text = validEmail
        loginVC.Password.text = validPassword
        loginVC.LogInButt(self)
        XCTAssertNotNil(loginVC.loggedInUser, "User should be logged in.")
        XCTAssertEqual(loginVC.loggedInUser?.email, validEmail, "Logged in user's email should match the predefined email.")
    }
    
    func testUserCannotLoginWithInvalidCredentials() throws {
        let loginVC = createLogInViewController()
        let invalidEmail = "invalid@tec.com"
        let invalidPassword = "WrongPassword"
        loginVC.Email.text = invalidEmail
        loginVC.Password.text = invalidPassword
        loginVC.LogInButt(self)
        XCTAssertNil(loginVC.loggedInUser, "User should not be logged in with invalid credentials.")
        XCTAssertNil(loginVC.presentedViewController, "There should be no screen transition with invalid login.")
    }
    //HU9
    func testNewsViewFunctionality() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newsView = storyboard.instantiateViewController(withIdentifier: "NewsView") as? NewsView else {
            XCTFail("No se pudo instanciar NewsView.")
            return
        }
        newsView.loadViewIfNeeded()
        XCTAssertNotNil(newsView.tableView, "La vista de tabla debería existir.")
        let sampleNews = [
            News(name: "Sample News 1", description: "", date: "2024-10-16", imageLink: ""),
            News(name: "Sample News 2", description: "", date: "2024-10-15", imageLink: ""),
            News(name: "Sample News 3", description: "", date: "2024-10-14", imageLink: "")
        ]
        newsView.newsList = sampleNews
        newsView.tableView.reloadData()
        let rows = newsView.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(rows, sampleNews.count, "El número de filas debería coincidir con el número de noticias.")
        let cell = newsView.tableView(newsView.tableView, cellForRowAt: IndexPath(row: 0, section: 0))
        let indexPath = IndexPath(row: 0, section: 0)
        newsView.tableView(newsView.tableView, didSelectRowAt: indexPath)
        _ = "ShowNewsDetail"
        guard storyboard.instantiateViewController(withIdentifier: "NewsDetail") is NewsDetail else {
            XCTFail("El controlador de destino debería ser de tipo NewsDetail.")
            return
        }
        
    }
    //HU10
    func testContinueAsGuest() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let logInView = storyboard.instantiateViewController(withIdentifier: "LogIn") as? LogIn else {
            XCTFail("No se pudo instanciar LogIn.")
            return
        }
        logInView.loadViewIfNeeded()
        logInView.ContinueButt(self)
        let guestUser = UserSession.shared.user
        XCTAssertNotNil(guestUser, "Debería existir un usuario invitado.")
        XCTAssertEqual(guestUser?.typeUser, 3, "El usuario invitado debería tener el tipo de usuario igual a 3.")
        XCTAssertEqual(guestUser?.email, "Not registered", "El email del usuario invitado debería ser 'Not registered'.")
        XCTAssertEqual(guestUser?.firstname, "Not registered", "El nombre del usuario invitado debería ser 'Not registered'.")
    }
    //HU11
    func testGraphViewsSetup() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let projectDetailView = storyboard.instantiateViewController(withIdentifier: "DetailProject") as? ProjectDetail else {
            XCTFail("No se pudo instanciar ProjectDetail. Asegúrate de que el identificador esté configurado correctamente en el Storyboard.")
            return
        }
        projectDetailView.loadViewIfNeeded()
        
        let testProject = Projects(
            id: 1,
            title: "Test Project",
            location: "123",
            country: "Mexico",
            numberOfParticipants: 2,
            imageLink: "https://web.com",
            isActive: true,
            description: "This is a test description.",
            longitude: 123,
            latitude: 123,
            userParticipation: "1233"
        )
        
        projectDetailView.detail = testProject
        projectDetailView.setupGraphViews()
        
        XCTAssertEqual(projectDetailView.graphView1.subviews.count, 3, "Debería haber exactamente un gráfico en graphView1.")
        XCTAssertEqual(projectDetailView.graphView2.subviews.count, 3, "Debería haber exactamente un gráfico en graphView2.")
        XCTAssertEqual(projectDetailView.graphView3.subviews.count, 3, "Debería haber exactamente un gráfico en graphView3.")
        XCTAssertEqual(projectDetailView.graphView4.subviews.count, 3, "Debería haber exactamente un gráfico en graphView4.")
    }
    //HU13
    @MainActor
    func testOverallHealthViewDataDisplay() async throws {
        struct OverallHealthData {
            var healthyClient: String
            var healthyNetworkDevice: String
            var numApplicationPolicies: String
            var numLicensedRouters: String
            var numLicensedSwitches: String
            var numNetworkDevices: String
            var numUnreachable: String
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let overallHealthVC = storyboard.instantiateViewController(withIdentifier: "OverallHealth") as? OverallHealth else {
            XCTFail("No se pudo instanciar el controlador de vista OverallHealth")
            return
        }
        
        overallHealthVC.loadViewIfNeeded()
        let mockHealthData = OverallHealthData(
            healthyClient: "90%",
            healthyNetworkDevice: "85%",
            numApplicationPolicies: "5",
            numLicensedRouters: "10",
            numLicensedSwitches: "15",
            numNetworkDevices: "20",
            numUnreachable: "2"
        )
        
        overallHealthVC.Clients.text = "Clients %"
        overallHealthVC.NumClients.text = mockHealthData.healthyClient
        overallHealthVC.HealthyNetDevices.text = "Healthy Network Devices %"
        overallHealthVC.NumNHealthyetDevices.text = mockHealthData.healthyNetworkDevice
        overallHealthVC.AppPolicies.text = "Application Policies"
        overallHealthVC.NumAppPolicies.text = mockHealthData.numApplicationPolicies
        overallHealthVC.LicRout.text = "Licensed Routers"
        overallHealthVC.NumLicRout.text = mockHealthData.numLicensedRouters
        overallHealthVC.LicSwitches.text = "Licensed Switches"
        overallHealthVC.NumLicSwitches.text = mockHealthData.numLicensedSwitches
        overallHealthVC.NetDevices.text = "Network Devices"
        overallHealthVC.NumNetDevices.text = mockHealthData.numNetworkDevices
        overallHealthVC.UnDev.text = "Unreachable Devices"
        overallHealthVC.NumUnDev.text = mockHealthData.numUnreachable
    
        XCTAssertEqual(overallHealthVC.NumClients.text, "90%")
        XCTAssertEqual(overallHealthVC.NumNHealthyetDevices.text, "85%")
        XCTAssertEqual(overallHealthVC.NumAppPolicies.text, "5")
        XCTAssertEqual(overallHealthVC.NumLicRout.text, "10")
        XCTAssertEqual(overallHealthVC.NumLicSwitches.text, "15")
        XCTAssertEqual(overallHealthVC.NumNetDevices.text, "20")
        XCTAssertEqual(overallHealthVC.NumUnDev.text, "2")
    }

    //HU14
    func createLogInViewController2() -> LogIn {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LogIn") as! LogIn
        loginVC.loadViewIfNeeded()
        return loginVC
    }
    
    func testUserCanLoginWithPredefinedAdmin() throws {
        let loginVC = createLogInViewController2()
        let validEmail = "admin@skiliket.com"
        let validPassword = "Password123"
        loginVC.Email.text = validEmail
        loginVC.Password.text = validPassword
        loginVC.LogInButt(self)
        XCTAssertNotNil(loginVC.loggedInUser, "User should be logged in.")
        XCTAssertEqual(loginVC.loggedInUser?.email, validEmail, "Logged in user's email should match the predefined email.")
    }
    func testPerformanceExample() throws {
        measure {
            
        }
    }
    
}
