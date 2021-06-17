//
//  DeleteViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/17.
//

import UIKit

class DeleteViewController: UIViewController {

    @IBOutlet weak var deleteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        deleteTextField.delegate = self
        deleteTextField.keyboardType = .numberPad
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
    }
    
    
}

extension DeleteViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        deleteTextField.resignFirstResponder()
    }
}
