//
//  Report.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 03/10/24.
//

import UIKit

class Report: UIViewController {
    var report: Projects?
    @IBOutlet weak var titleReport: UILabel!
    @IBOutlet weak var Project: UILabel!
    @IBOutlet weak var ProjectTitle: UILabel!
    @IBOutlet weak var SelectTopicTitle: UILabel!
    @IBOutlet weak var Variables: UIButton!
    @IBOutlet weak var ReportText: UITextField!
    @IBOutlet weak var SendReportButt: UIButton!
    @IBOutlet weak var variablesSelection: UIButton!
    
    @IBAction func ButtonSendReport(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "Dashboard") as? Dashboard {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    
    var selectedVariables = Set<String>()
    let allVariables = ["Temperature", "Atmospheric pressure", "Smoke sensor", "Wind sensor", "Humidity", "Movement sensor", "Noise sensor", "Water sensor"]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        setupVariablesSelectionMenu()
        //ProjectTitle.text = report?.title
        titleReport.layer.shadowColor = UIColor.darkGray.cgColor
        titleReport.layer.shadowOpacity = 0.5
        titleReport.layer.shadowOffset.width = .zero
        titleReport.layer.shadowOffset.height = 4
        
        ReportText.addLine(position: .bottom, color: .darkGray, width: 0.75)
        
    }


}
