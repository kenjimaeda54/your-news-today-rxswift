//
//  News.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import Foundation

struct News: Decodable  {
	let articles: [Articles]	
}

struct Articles: Decodable {
	let title: String
	let description: String
	let urlToImage: String
}
