//
//  SentMemesTableViewController.swift
//  MemeMe 2.0
//
//  Created by André Sanches Bocato on 20/12/18.
//  Copyright © 2018 André Sanches Bocato. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        return delegate.memes
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
//        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
//        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
}

