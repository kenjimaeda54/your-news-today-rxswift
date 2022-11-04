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
	let weather: WeatherMoreInformation
	
}

struct Main:Decodable {
	let temp: Double
	let humidity: Double
	let tempMax: Double
	
	enum CodingKeys: String, CodingKey {
		   case temp
		   case humidity
			 case tempMax = "temp_max"
	 }
	
}



struct Wind:Decodable {
	let speed: Double
}

struct WeatherMoreInformation: Decodable {
	let icon: String
}
