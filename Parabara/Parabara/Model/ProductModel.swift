//
//  ProductModel.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/15.
//

import Foundation

struct ProductModel: Codable {
    let status: Int
    let data: [Data]
}

struct Data: Codable {
    let rows: [Rows]
}

struct Rows: Codable {
    let id: Int
    let title: String
    let content: String
    let price: Int
    let images: [String]
}
