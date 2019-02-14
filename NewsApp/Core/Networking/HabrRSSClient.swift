//
//  HabrRSSClient.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation

private enum Constants {
	static let baseURL = "https://habr.com/ru/rss/hubs/"
}

final class HabrRSSClient {
	
	func getRSSFeed(completion: @escaping (Data?, Error?) -> Void) {
		guard let url = URL(string: Constants.baseURL) else { return }
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			DispatchQueue.main.async {
				completion(data, error)
			}
		}
		task.resume()
	}
	
}
