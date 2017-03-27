//
//  MovieViewCell.swift
//  Flicks
//
//  Created by alan_hamlett on 3/26/17.
//  Copyright © 2017 Alan Hamlett. All rights reserved.
//

import UIKit

class MovieViewCell: UITableViewCell {

  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var moviePosterView: UIImageView!

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
