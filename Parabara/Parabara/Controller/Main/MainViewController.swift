//
//  MainViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/15.
//

import UIKit
import Alamofire
import Kingfisher

class MainViewController: UIViewController {

    var model: ProductModel?
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        apiCall()
    }
    
    func setting() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.tableFooterView = UIView()
    }
    
    func apiCall() {
        let URL = "https://api.recruit-test.parabara.kr/api/product"
        let token = "eyJpZCI6ODk9MiwicGhvbm"
        AF.request(URL, method: .get, headers: ["x-token": token]).responseData { data in
            guard let data = data.data else { return }
            self.model = try? JSONDecoder().decode(ProductModel.self, from: data)
            self.mainTableView.reloadData()
            print(data)
        }
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("2")
        return model?.data.records ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        let url = URL(string: (model?.data.rows[indexPath.row].images[0] ?? ""))
        
        cell.mainTitle.text = model?.data.rows[indexPath.row].title
        cell.mainPrice.text = "\(model?.data.rows[indexPath.row].price ?? 0)원"
        cell.mainImageView.kf.setImage(with: url)
        
        print("1")
        return cell
    }
}
