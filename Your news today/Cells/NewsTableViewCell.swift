//
//  NewsTableViewCell.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

	@IBOutlet weak var imgNews: UIImageView!
	@IBOutlet weak var labDescription: UILabel!
	@IBOutlet weak var labTitle: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
