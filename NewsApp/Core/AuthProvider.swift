//
//  AuthProvider.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation

enum AuthError: LocalizedError {
	case invalidCredentials
	
	var errorDescription: String? {
		switch self {
		case .invalidCredentials:
			return "Invalid email or password"
		}
	}
}

final class AuthProvider {
	
	private let persistenceManager = PersistenceManager.shared
	
	var isLoggedIn: Bool {
		return currentUser == nil ? false : true
	}
	var currentUser: UserEntity? {
		return persistenceManager.fetchFirst(UserEntity.self)
	}
	
	func login(email: String?, password: String?) throws {
		guard let email = email, email == Constants.validEmail,
			let password = password, password == Constants.validPassword else {
				throw AuthError.invalidCredentials
		}
		
		let userObject = UserEntity(context: persistenceManager.context)
		userObject.email = email
		persistenceManager.save()
	}
	
	func logout() {
		guard let currentUser = currentUser else { return }
		persistenceManager.delete(currentUser)
	}
	
}
