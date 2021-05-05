//
//  FileManager.swift
//  Memey Boi
//
//  Created by Gavin Craft on 5/5/21.
//

import UIKit
class InsideFileManager{
    static let shared = InsideFileManager()
    var documentDirectory: URL
    init(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        documentDirectory = paths[0]
    }
    
    func saveAsPng(image: UIImage, name: String){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
    }
}
