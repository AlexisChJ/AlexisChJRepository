//
//  ProjectDetail.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 06/10/24.
//

import UIKit
import SwiftUI

class ProjectDetail: UIViewController {
    var detail: Projects?
    @IBOutlet weak var t: UILabel!
    var selectedVariables: [String] = []
    @IBOutlet weak var titleDescription: UITextView!
    @IBOutlet weak var graphView1: UIView!
    @IBOutlet weak var graphView2: UIView!
    @IBOutlet weak var graphView3: UIView!
    @IBOutlet weak var graphView4: UIView!
    @IBOutlet weak var variableSelector: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGraph()
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] timer in
            self?.updateGraph()
        }
        //setupGraphViews()
        t.text = detail?.title
        titleDescription.text = detail?.description
        variableSelector.addTarget(self, action: #selector(selectVariables), for: .touchUpInside)
    }
    func updateGraph() {
        for subview in graphView1.subviews {
            subview.removeFromSuperview()
        }
        
        let graph1 = UIHostingController(
            rootView: TemperatureLineChartUIView(selectedVariables: selectedVariables, updateSelectedVariables: { variable in
                self.toggleVariableSelection(variable)
            }, projectID: detail?.id ?? 1)
        )
        
        addChild(graph1)
        graphView1.addSubview(graph1.view)
        
        graph1.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            graph1.view.topAnchor.constraint(equalTo: graphView1.topAnchor),
            graph1.view.bottomAnchor.constraint(equalTo: graphView1.bottomAnchor),
            graph1.view.leadingAnchor.constraint(equalTo: graphView1.leadingAnchor),
            graph1.view.trailingAnchor.constraint(equalTo: graphView1.trailingAnchor)
        ])
        graph1.didMove(toParent: self)
    }
    
    
    @objc func selectVariables() {
        let alert = UIAlertController(title: "Select Variables", message: "Choose variables to display", preferredStyle: .alert)
        let variables = ["Temperature", "Humidity", "Wind", "Atmospheric Pressure"]
        
        for variable in variables {
            alert.addAction(UIAlertAction(title: variable, style: .default, handler: { action in
                if let variable = action.title {
                    self.toggleVariableSelection(variable)
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: { _ in
            self.updateGraph()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    private func toggleVariableSelection(_ variable: String) {
        if let index = selectedVariables.firstIndex(of: variable) {
            selectedVariables.remove(at: index)
        } else {
            selectedVariables.append(variable)
        }
        updateSelectedVariablesLabel()
        updateGraph()
    }
    
    private func updateSelectedVariablesLabel() {
        let title = selectedVariables.isEmpty ? "Select Variables" : selectedVariables.joined(separator: ", ")
        variableSelector.setTitle(title, for: .normal)
    }
    
}
