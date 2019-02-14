//
//  ProfileContainerViewController.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import UIKit

class ProfileContainerViewController: BaseContainer {
	
	private let authProvider = AuthProvider()
	
	private lazy var loginViewController: UIViewController = {
		let controller = LoginViewController.instantiateFromStoryboard(storyboard: UIStoryboard.mainStoryboard())
		controller.delegate = self
		return controller
	}()
	private lazy var profileViewController: UIViewController = {
		let controller = LoginViewController.instantiateFromStoryboard(storyboard: UIStoryboard.mainStoryboard())
		controller.delegate = self
		return controller
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let viewController = authProvider.isLoggedIn ? profileViewController : loginViewController
		showContainedController(viewController, container: view)
    }

}

// MARK: - LoginViewControllerDelegate
extension ProfileContainerViewController: LoginViewControllerDelegate {
	
	func didLogin(email: String?, password: String?) {
		do {
			try authProvider.login(email: email, password: password)
		} catch {
			showErrorAlert(message: error.localizedDescription)
			return
		}
		
		replaceContainedController(from: loginViewController, to: profileViewController, container: view, animated: true)
	}
	
}

// MARK: - ProfileViewControllerDelegate
extension ProfileContainerViewController: ProfileViewControllerDelegate {
	
	func didLogout() {
		authProvider.logout()
		
		replaceContainedController(from: profileViewController, to: loginViewController, container: view, animated: true)
	}
	
}
