//
//  NewsTableViewCell.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import UIKit
import RxCocoa
import RxSwift

class NewsTableViewCell: UITableViewCell {

	//MARK: - IBOutlet
	@IBOutlet weak var imgNews: UIImageView!
	@IBOutlet weak var labDescription: UILabel!
	@IBOutlet weak var labTitle: UILabel!
	
	//MARK: - Vars
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
	
		
	}
	
	func prepareImg(_ imgUrl: String) {
		let urlImgData = URL(string: imgUrl)!
		
		imgNews.layer.cornerRadius = 5
		
		DispatchQueue.global().async {
			
			if let data = try? Data(contentsOf: urlImgData ) {
				
				DispatchQueue.main.async {
					self.imgNews.image = UIImage(data: data)
					
				}
							
			}
		}
	}
	
}
