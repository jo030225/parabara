//
//  ProductRegisterViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/18.
//

import UIKit
import Alamofire

class ProductRegisterViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        checkTextField() ? checkAlert() : failAlert(message: "빈칸을 채우세요.")
    }
    
    func setting() {
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.cornerRadius = 5
        
        titleTextField.delegate = self
        priceTextField.delegate = self
        contentTextView.delegate = self
    }
    
    func registerApi(title: String, content: String, price: Int, images: Int) {
        let URL = "https://api.recruit-test.parabara.kr/api/product"
        let token = "eyJpZCI6ODk9MiwicGhvbm"
        let PARAM: Parameters = [
            "title": title,
            "content": content,
            "price": price,
            "images": images
        ]
        
        AF.request(URL, method: .post, parameters: PARAM, headers: ["x-token":token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                switch response.response?.statusCode {
                case 200:
                    self.successAlert()
                    print("성공")
                case 500:
                    self.failAlert(message: "Server Error")
                    print("Server Error")
                case 403:
                    self.failAlert(message: "권한 없음")
                    print("권한 없음")
                default:
                    self.failAlert(message: "알 수 없는 오류")
                    print("알 수 없는 오류")
                }
                print(value)
            case .failure(let error):
                self.failAlert(message: "네트워크 연결 확인해주세요.")
                print(error)
            }
        }
    }
    
    func checkTextField() -> Bool {
        return titleTextField.text == "" || contentTextView.text == "" || priceTextField.text == "" ? false : true
    }
    
    func checkAlert() {
        let alert = UIAlertController(title: "알림", message: "정말 상품 등록을 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.registerApi(title: self.titleTextField.text ?? "", content: self.contentTextView.text ?? "", price: Int(self.priceTextField.text ?? "") ?? 0, images: ImageManager.getImageId())
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "상품 등록 완료", message: "상품 등록 완료!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default){ (_) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "상품 등록 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: UITextFieldDelegate, UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
