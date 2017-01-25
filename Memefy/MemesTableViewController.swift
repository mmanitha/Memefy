//
//  MemesTableViewController.swift
//  Memefy
//
//  Created by Michael Manisa on 1/16/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import UIKit

class MemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Outlets
    @IBOutlet weak var memesTable: UITableView!
    
    var memes = [Meme]()
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.storedMemes
        self.memesTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }

    //MARK: Memes Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MemeTableViewCell = memesTable.dequeueReusableCell(withIdentifier: "cell")! as! MemeTableViewCell
        cell.memeLabel.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        cell.memeImage.image = memes[indexPath.row].memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //get the storyboard and the detail VC
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        
        //communicate what was selected
        nextVC.selectedMeme = memes[indexPath.row]
        
        //present Detail VC
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
