//
//  MovieDetailViewController.swift
//  Flicks
//
//  Created by alan_hamlett on 3/26/17.
//  Copyright © 2017 Alan Hamlett. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  @IBOutlet weak var posterImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var infoView: UIView!

  var movie: NSDictionary!

  override func viewDidLoad() {
    super.viewDidLoad()

    titleLabel.text = movie["title"] as! String
    overviewLabel.text = movie["overview"] as! String

    let posterBaseUrl = "https://image.tmdb.org/t/p/w500"
    if let posterPath = movie["poster_path"] as? String {
      let posterUrl = NSURL(string:posterBaseUrl + posterPath)
      posterImage.setImageWith(posterUrl as! URL)
    }

    scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + titleLabel.frame.size.height + overviewLabel.frame.size.height)

    overviewLabel.sizeToFit()

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
