//
//  DeleteViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/17.
//

import UIKit
import Alamofire

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
        checkTextField() ? checkAlert(id: deleteTextField.text ?? "") : failAlert(message: "빈칸을 채우세요.")
    }
    
    func deleteApiCall(id: String) {
        let URL = "https://api.recruit-test.parabara.kr/api/product/\(id)"
        let token = "eyJpZCI6ODk9MiwicGhvbm"
        AF.request(URL, method: .delete, headers: ["x-token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                switch (response.response?.statusCode)! {
                case 200:
                    self.successAlert(id: self.deleteTextField.text ?? "")
                case 403:
                    self.failAlert(message: "권한이 없습니다.")
                case 500:
                    self.failAlert(message: "Server Error")
                default:
                    self.failAlert(message: "알 수 없는 에러")
                }
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkTextField() -> Bool {
        return deleteTextField.text == "" ? false : true
    }
    
    func checkAlert(id: String) {
        let alert = UIAlertController(title: "알림", message: "정말 \(id)를 삭제하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.deleteApiCall(id: self.deleteTextField.text ?? "")
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func successAlert(id: String) {
        let alert = UIAlertController(title: "알림", message: "\(id) 삭제가 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "삭제 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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
