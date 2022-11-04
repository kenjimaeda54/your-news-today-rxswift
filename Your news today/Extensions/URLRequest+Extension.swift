//
//  URLRequest+Extension.swift
//  Your news today
//
//  Created by kenjimaeda on 03/11/22.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
	
	let url: URL
	
}


extension URLRequest {
	
	func load<T>(_ resoure: Resource<T>) -> Observable<T> {		
		Observable.just(resoure.url).flatMap { url -> Observable<Data> in
			let urlRequest = URLRequest(url: url)
			return URLSession.shared.rx.data(request: urlRequest)
		}.map { data -> T in
			return try JSONDecoder().decode(T.self, from: data)
		}
	}
	
}
