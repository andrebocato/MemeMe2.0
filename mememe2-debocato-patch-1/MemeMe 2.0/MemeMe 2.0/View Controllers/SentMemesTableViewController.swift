//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by André Sanches Bocato on 20/12/18.
//  Copyright © 2018 André Sanches Bocato. All rights reserved.
//
// working fine, but only the first meme created show up on the top of the list

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return delegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        //  Set the name and image
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard
        let storyboard = UIStoryboard(name: "MemeDetailViewController", bundle: nil)
        let detailController = storyboard.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        // Populate view controller with data from the selected item
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        let navigationController = UINavigationController()
        navigationController.pushViewController(detailController, animated: true)
    }
}

