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
    
    func setting() {
        picker.delegate = self
    }
    @IBAction func imageAddButton(_ sender: UIBarButtonItem) {
        alert()
    }
    
    func imageUploadApi(data: Data) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: "\(data).jepg")
        }, to: "https://api.recruit-test.parabara.kr/api/product/upload", method: .post, headers: ["x-token": "eyJpZCI6ODk9MiwicGhvbm"]).responseJSON { response in
            switch response.result {
            case .success(let value):
                print(value)
                switch response.response?.statusCode {
                case 200:
                    print("200")
                case 500:
                    print("500")
                case 403:
                    print("403")
                default:
                    print("알 수 없는 오류")
                }
            case .failure(let error):
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
