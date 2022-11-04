//
//  Weather.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import Foundation

struct Weather:Decodable {
	let main: Main
	let wind: Wind
	
}

struct Main: Decodable {
	let temp: Double
	let humidity: Double
	
}

struct Wind:Decodable {
	let speed: Double
}

