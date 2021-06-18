//
//  ImageManager.swift
//  Parabara
//
//  Created by 조주혁 on 2021/06/18.
//

import Foundation

class ImageManager {
    
    static var imageId: Int?
    
    class func getImageId() -> Int {
        guard let id = imageId else { return 0}
        return id
    }
    
    class func setImageId(id: Int) {
        imageId = id
    }
    
    class func removeImageId() {
        imageId = nil
    }
    
}
