//
//  MemeCollectionViewController.swift
//  Memefy
//
//  Created by Michael Manisa on 1/16/17.
//  Copyright © 2017 Michael Manisa. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var memes = [Meme]()
    
    //MARK: Outlets
    
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.storedMemes
        self.memeCollectionView.reloadData()
    }
    
    //Constants for Collection View Flow Layout
    
    let space: CGFloat = 3
    let itemsInRowForVerLayout: CGFloat = 3
    let itemsInRowForHorLayout: CGFloat = 5
    
    
    //MARK: Collection View Flow Layout Delegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //get the frame
        let frame = memeCollectionView.frame.size
        
        //get the width
        let width = frame.width
        
        //get the dimension of one side of an item depending on orientation of device
        let dimension: CGFloat = (frame.height > frame.width) ? ((width - ((itemsInRowForVerLayout - 1) * space)) / itemsInRowForVerLayout) : ((width - ((itemsInRowForHorLayout - 1) * space)) / itemsInRowForHorLayout)
        
        //get the item size
        let itemSize: CGSize = CGSize(width: dimension, height: dimension)
        
        //return item size
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        //set the spacing between items in a row in a section
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        //set the spacing between rows in a section
        return space
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //recalculate flow layout when orientation of device changes
        self.memeCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //load data after view appears
        loadData()
    }
    
    
    //MARK: Collection View DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MemeCollectionViewCell = memeCollectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImage.image = self.memes[indexPath.row].memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //get the storyboard and the detail VC
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        
        //communicate what was selected
        nextVC.selectedMeme = memes[indexPath.row]
        
        //present Detail VC
        navigationController?.pushViewController(nextVC, animated: true)
        
    }

}
