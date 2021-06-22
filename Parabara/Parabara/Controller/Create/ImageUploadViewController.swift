//
//  ImageUploadViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/17.
//

import UIKit
import Alamofire

class ImageUploadViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    @IBAction func imageAddButton(_ sender: UIBarButtonItem) {
        alert()
    }
    
    func setting() {
        picker.delegate = self
    }
    
    func imageUploadApi(data: Data) {
        let URL = "https://api.recruit-test.parabara.kr/api/product/upload"
        let token = "eyJpZCI6ODk9MiwicGhvbm"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: "\(data).jepg")
        }, to: URL, method: .post, headers: ["x-token": token]).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                switch response.response?.statusCode {
                case 200:
                    self.successAlert()
                    if let dic = value as? NSDictionary,
                       let data = dic["data"] as? NSDictionary,
                       let id = data["id"] as? Int {
                        ImageManager.setImageId(id: id)
                    }
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
            case .failure(let error):
                self.failAlert(message: "네트워크 연결 확인해주세요.")
                print(error)
            }
        }
    }
    
    func alert() {
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func successAlert() {
        let alert = UIAlertController(title: "업로드 완료", message: "업로드 완료!!!", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func failAlert(message: String) {
        let alert = UIAlertController(title: "업로드 실패", message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
}

extension ImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        guard let imageData = image.jpegData(compressionQuality: 0.1) else { return }
        imageView.image = image
        imageUploadApi(data: imageData)
        
        dismiss(animated: true, completion: nil)
    }
}
