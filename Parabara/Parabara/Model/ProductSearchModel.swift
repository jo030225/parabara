//
//  ProductSearchModel.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/16.
//

import Foundation

struct ProductSearchModel: Codable {
    let status: Int
    let data: ProductSearchData
    let message: String
}

struct ProductSearchData: Codable {
    let id: Int
    let title: String
    let content: String
    let price: Int
    let images: [String]
}
