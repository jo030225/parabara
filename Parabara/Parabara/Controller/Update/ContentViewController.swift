//
//  ContentViewController.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/20.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setting()
    }
    
    func setting() {
        titleLabel.text = ContentManager.getProductTitle()
        contentLabel.text = ContentManager.getProductContent()
        priceLabel.text = "\(ContentManager.getProductPrice())원"
        idLabel.text = "\(ContentManager.getProductId())"
    }
}
