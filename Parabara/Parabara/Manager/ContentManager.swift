//
//  ContentManager.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/20.
//

import Foundation

class ContentManager {
    static var productId: Int?
    static var productTitle: String?
    static var productContent: String?
    static var productPrice: Int?
    
    
    // 상품 아이디
    class func getProductId() -> Int {
        guard let id = productId else { return 0 }
        return id
    }
    
    class func setProductId(id: Int) {
        productId = id
    }
    
    class func removeProductId() {
        productId = nil
    }
    
    
    // 상품 제목
    class func getProductTitle() -> String {
        guard let title = productTitle else { return "" }
        return title
    }
    
    class func setProductTitle(title: String) {
        productTitle = title
    }
    
    class func removeProductTitle() {
        productTitle = nil
    }
    
    
    // 상품 내용
    class func getProductContent() -> String {
        guard let content = productContent else { return "" }
        return content
    }
    
    class func setProductContent(content: String) {
        productContent = content
    }
    
    class func removeProductContent() {
        productContent = nil
    }
    
    
    // 상품 가격
    class func getProductPrice() -> Int {
        guard let price = productPrice else { return 0 }
        return price
    }
    
    class func setProductPrice(price: Int) {
        productPrice = price
    }
    
    class func removeProductPrice() {
        productPrice = nil
    }
    
}
