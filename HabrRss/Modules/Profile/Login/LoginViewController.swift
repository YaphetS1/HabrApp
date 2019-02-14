//
//  LoginViewController.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
	func didLogin(email: String?, password: String?)
}

class LoginViewController: UIViewController {

	weak var delegate: LoginViewControllerDelegate?
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		emailTextField.text = Constants.validEmail
		passwordTextField.text = Constants.validPassword
    }
	
	@IBAction func loginPressed(_ sender: UIButton) {
		delegate?.didLogin(email: emailTextField.text,
						   password: passwordTextField.text)
	}

}
