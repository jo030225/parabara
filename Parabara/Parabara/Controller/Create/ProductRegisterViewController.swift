//
//  ProductRegisterViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/18.
//

import UIKit

class ProductRegisterViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    func setting() {
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.cornerRadius = 5
        
        titleTextField.delegate = self
        priceTextField.delegate = self
        contentTextView.delegate = self
    }
}

extension ProductRegisterViewController: UITextFieldDelegate, UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
