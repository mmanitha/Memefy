//
//  Meme.swift
//  Memefy
//
//  Created by Michael Manisa on 12/14/16.
//  Copyright © 2016 Michael Manisa. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.bottomText = bottomText
        self.topText = topText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
