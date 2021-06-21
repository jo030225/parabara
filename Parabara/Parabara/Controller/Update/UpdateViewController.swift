//
//  UpdateViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/20.
//

import UIKit
import Alamofire

class UpdateViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setting()
    }
    
    @IBAction func updateButton(_ sender: UIButton) {
        checkAlert()
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
    
    func updateApi(id: Int, title: String, content: String, price: Int) {
        let URL = "https://api.recruit-test.parabara.kr/api/product"
        let token = "eyJpZCI6ODk9MiwicGhvbm"
        let PARAM: Parameters = [
            "id": id,
            "title": title,
            "content": content,
            "price": price
        ]
        
        AF.request(URL, method: .put, parameters: PARAM, headers: ["x-token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                switch response.response?.statusCode {
                case 200:
                    self.successAlert()
                    print("200")
                case 403:
                    self.failAlert(message: "권한 없음")
                    print("403")
                case 500:
                    self.failAlert(message: "Server Error")
                    print("500")
                default:
                    self.failAlert(message: "알 수 없는 오류")
                    break
                }
                print(value)
            case .failure(let error):
                self.failAlert(message: "네트워크 연결 확인해주세요.")
                print(error)
            }
        }
    }
    
    func checkAlert() {
        let alert = UIAlertController(title: "알림", message: "정말로 상품을 수정 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.updateApi(id: ContentManager.getProductId(), title: self.titleTextField.text ?? "", content: self.contentTextView.text ?? "", price: Int(self.priceTextField.text ?? "") ?? 0)
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "상품 수정 완료", message: "상품 수정 완료!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "상품 수정 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension UpdateViewController: UITextFieldDelegate, UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
