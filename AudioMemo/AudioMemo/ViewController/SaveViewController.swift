//
//  SaveViewController.swift
//  AudioMemo
//
//  Created by Kilian Kellermann on 31.07.19.
//  Copyright © 2019 Kilian Kellermann. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var categoryButtons: [UIButton]!
    
    var category = "Important"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameTextField.delegate = self
    }
    
    func updateCategory(for title: String) {
        category = title
        for button in categoryButtons {
            if button.titleLabel?.text == title {
                button.setTitleColor(.red, for: .normal)
            } else {
                button.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func saveNewFile() {
        if let name = nameTextField.text {
            if !name.isEmpty {
                let filename = name + ".caf"
                if Utility.moveAudioFile(to: category, with: filename) {
                    dismiss(animated: true, completion: nil)
                } else {
                    showAlert(reason: 1)
                }
            } else {
                showAlert(reason: 0)
            }
        }
    }
    
    func showAlert(reason: Int) {
        let message = reason == 0 ? "Please enter a name first!" : "The file could not be saved. Did you maybe choose a duplicate name?"
        let alertViewController = UIAlertController(title: "Could not save file", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    @IBAction func buttonHandler(_ sender: UIButton) {
        if let title = sender.titleLabel?.text {
            switch title {
            case "Important", "Today":
                updateCategory(for: title)
            case "Save":
                saveNewFile()
            case "BACK":
                dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
}

extension SaveViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
