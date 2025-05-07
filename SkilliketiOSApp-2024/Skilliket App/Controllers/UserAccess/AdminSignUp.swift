//
//  AdminSignUp.swift
//  Skilliket App
//
//  Created by Alexis Chávez on 22/09/24.
//

import UIKit
import UniformTypeIdentifiers

class AdminSignUp: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var ResumeTitle: UILabel!
    @IBOutlet weak var Send: UIButton!
    @IBOutlet weak var EducationLevel: UIButton!
    @IBOutlet weak var Summary: UITextView!
    @IBOutlet weak var Projects: UITextView!
    
    @IBOutlet weak var BackButton: UIImageView!
    @IBAction func BackButtonAction(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "SignUp") as? SignUp {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    @IBAction func SendButt(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let transtition = storyboard.instantiateViewController(withIdentifier: "Verification") as? Verification {
            transtition.modalPresentationStyle = .fullScreen
            self.present(transtition, animated: false, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "document.badge.plus"), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.tintColor = .systemRed
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    
    @objc func uploadButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content, UTType.item], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        ResumeTitle.layer.shadowColor = UIColor.darkGray.cgColor
        ResumeTitle.layer.shadowOpacity = 0.5
        ResumeTitle.layer.shadowOffset.width = .zero
        ResumeTitle.layer.shadowOffset.height = 4
        
        Summary.delegate = self
        Summary.layer.borderColor = UIColor.systemGray5.cgColor
        Summary.layer.borderWidth = 0.8
        Summary.layer.cornerRadius = 5
        
        Projects.delegate = self
        Projects.layer.borderColor = UIColor.systemGray5.cgColor
        Projects.layer.borderWidth = 0.8
        Projects.layer.cornerRadius = 5
        
        let highSchoolAction = UIAction(title: "High School", handler: { _ in })
        let bachelorsAction = UIAction(title: "Bachelor's Degree", handler: { _ in })
        let mastersAction = UIAction(title: "Master's Degree", handler: { _ in })
        let phdAction = UIAction(title: "PhD", handler: { _ in })
        let educationMenu = UIMenu(title: "Select Education Level", options: .displayInline, children: [highSchoolAction, bachelorsAction, mastersAction, phdAction])
        EducationLevel.menu = educationMenu
        EducationLevel.showsMenuAsPrimaryAction = true
        view.addSubview(uploadButton)
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            uploadButton.centerXAnchor.constraint(equalTo: Send.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: Send.topAnchor, constant: -100)
        ])
        
        NSLayoutConstraint.activate([
            uploadButton.centerXAnchor.constraint(equalTo: Send.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: Send.topAnchor, constant: -100)
        ])
        Send.titleLabel?.textAlignment = .center
        Send.contentHorizontalAlignment = .center

        
        // let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        // view.addGestureRecognizer(tapGesture2)
        
        
        BackButton.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BackButtonAction(_:)))
            BackButton.addGestureRecognizer(tapGesture)
    }
}

extension AdminSignUp: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // Verificar si se seleccionó un documento
        guard let selectedFileURL = urls.first else { return }
        
        // Aquí puedes manejar el archivo seleccionado
        print("Selected file URL: \(selectedFileURL)")
        
        // Cambiar la imagen del botón de carga y su color
        updateUploadButtonWithImage()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Manejar la cancelación del selector de documentos
        print("Document picker was cancelled.")
    }
    
    private func updateUploadButtonWithImage() {
        let attributedString = NSMutableAttributedString()

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "document")
        imageAttachment.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
        attributedString.append(NSAttributedString(attachment: imageAttachment))

        let text = NSAttributedString(string: " File Uploaded", attributes: [.foregroundColor: UIColor.systemGreen])
        attributedString.append(text)

        uploadButton.setAttributedTitle(attributedString, for: .normal)
    }
}
