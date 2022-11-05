//
//  News.swift
//  Your news today
//
//  Created by kenjimaeda on 05/11/22.
//

import Foundation
import RxSwift
import RxCocoa

struct NewsViewModel {
	
	let article: Articles
	
	init(_ article: Articles) {
		self.article = article
	}
	
}

extension NewsViewModel   {
	
	var title: Observable<String>  {
		return  Observable.just(article.title)
	}
	
	var description: Observable<String?> {
		return Observable.just(article.description)
	}
	
	var urlToImage: Observable<String?> {
		return Observable.just(article.urlToImage)
	}
	
	
}

struct NewsListViewModel  {
	
	let articlesVM: [NewsViewModel]
	
	
}

extension NewsListViewModel  {
	
	init(_ articles: [Articles]) {
		articlesVM =  articles.compactMap(NewsViewModel.init)
	}
	
}

extension NewsListViewModel   {
	
	func elementAt(_ index: Int) -> NewsViewModel  {
    
		return articlesVM[index]
 
	}
	

}







