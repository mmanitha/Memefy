//
//  MemeDetailViewController.swift
//  Memefy
//
//  Created by Michael Manisa on 1/17/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var selectedMeme: Meme?

    @IBOutlet weak var bottomText: UILabel!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sm = selectedMeme {
            bottomText.text = sm.bottomText
            topText.text = sm.topText
            memeImage.image = sm.memedImage
        }
    }
    
}
