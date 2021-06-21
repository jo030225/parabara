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
    var searchModel: ProductSearchModel?
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
        searchControllerSetting()
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
    
    func searchControllerSetting() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "상품 ID 검색"
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
    
    func searchApiCall(id: String) {
        let URL = "https://api.recruit-test.parabara.kr/api/product/\(id)"
        let encodingURL = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let token = "eyJpZCI6ODk9MiwicGhvbm"
        AF.request(encodingURL, method: .get, headers: ["x-token": token]).responseData(completionHandler: { data in
            guard let data = data.data else { return }
            self.searchModel = try? JSONDecoder().decode(ProductSearchModel.self, from: data)
            self.mainTableView.reloadData()
            print(data)
        })
    }
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFiltering) {
            return searchModel?.status == 200 ? 1 : 0
        } else {
            return model?.data.records ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        
        if isFiltering {
            let url = searchModel?.data.images[0] ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.mainTitle.text = searchModel?.data.title
            cell.mainPrice.text = "\(searchModel?.data.price ?? 0)원"
            cell.mainId.text = "\(searchModel?.data.id ?? 0)"
            cell.mainImageView.kf.setImage(with: URL(string: encodingURL))
        } else {
            let url = model?.data.rows[indexPath.row].images[0] ?? ""
            let encodingURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            cell.mainTitle.text = model?.data.rows[indexPath.row].title
            cell.mainPrice.text = "\(model?.data.rows[indexPath.row].price ?? 0)원"
            cell.mainId.text = "\(model?.data.rows[indexPath.row].id ?? 0)"
            cell.mainImageView.kf.setImage(with: URL(string: encodingURL))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ContentManager.setProductId(id: model?.data.rows[indexPath.row].id ?? 0)
        ContentManager.setProductTitle(title: model?.data.rows[indexPath.row].title ?? "")
        ContentManager.setProductContent(content: model?.data.rows[indexPath.row].content ?? "")
        ContentManager.setProductPrice(price: model?.data.rows[indexPath.row].price ?? 0)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchApiCall(id: searchController.searchBar.text ?? "")
    }
}
