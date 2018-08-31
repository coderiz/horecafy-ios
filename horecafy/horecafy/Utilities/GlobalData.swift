//
//  GlobalData.swift
//  horecafy
//
//  Created by aipxperts on 23/08/18.
//  Copyright © 2018 Pedro Martin Gomez. All rights reserved.
//

import Foundation
import UIKit

class GlobalData {
    
    class var sharedInstance: GlobalData {
        struct Singleton {
            static let instance = GlobalData()
        }
        return Singleton.instance
    }
    
    func resizedImage(withImage: UIImage, scaledTonewSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(scaledTonewSize, false, 1.0)
        withImage.draw(in: CGRect(x: 0, y: 0, width: scaledTonewSize.width, height: scaledTonewSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
//        drawingImageView.image = newImage
        return newImage ?? UIImage()
    }
}


