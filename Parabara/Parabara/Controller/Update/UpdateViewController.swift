//
//  UpdateViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/20.
//

import UIKit

class UpdateViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setting()
    }
    
    func setting() {
        titleTextField.delegate = self
        contentTextView.delegate = self
        priceTextField.delegate = self
        
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.cornerRadius = 5
        
        titleTextField.text = ContentManager.getProductTitle()
        contentTextView.text = ContentManager.getProductContent()
        priceTextField.text = "\(ContentManager.getProductPrice())"
    }
}

extension UpdateViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
