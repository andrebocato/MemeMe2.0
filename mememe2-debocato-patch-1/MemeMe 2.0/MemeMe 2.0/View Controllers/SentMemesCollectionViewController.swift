//
//  SentMemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by André Sanches Bocato on 20/12/18.
//  Copyright © 2018 André Sanches Bocato. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return delegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - 2 * space) / 3.0
        let height = (view.frame.size.height - 2 * space) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[(indexPath as NSIndexPath).row]

        // Set the meme image
        cell.memeImageView?.image = meme.memedImage

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let storyboard = UIStoryboard(name: "MemeDetailViewController", bundle: nil)
        let memeDetailController = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

        // Populate view controller with data from the selected item
        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]

        // Present the view controller using navigation
        let navigationController = UINavigationController()
        navigationController.pushViewController(memeDetailController, animated: true)
    }
}
