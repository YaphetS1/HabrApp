//
//  ProfileViewController.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
	func didLogout()
}

class ProfileViewController: UIViewController {
	
	weak var delegate: ProfileViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	@IBAction func favoritesPressed(_ sender: UIButton) {
		print(#function)
	}
	
	@IBAction func logoutPressed(_ sender: UIButton) {
		delegate?.didLogout()
	}

}
