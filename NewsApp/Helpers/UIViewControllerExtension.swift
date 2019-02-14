//
//  UIViewControllerExtension.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved. on 14/02/2019.
//

import UIKit
import MBProgressHUD

protocol StoryboardInstantiable: class {
	static var storyboardIdentifier: String { get }
	static func instantiateFromStoryboard(storyboard: UIStoryboard) -> Self
}

extension UIViewController {
	
	func showHUD() {
		MBProgressHUD.showAdded(to: view, animated: true)
	}
	
	func hideHUD() {
		MBProgressHUD.hide(for: view, animated: true)
	}
	
	func showErrorAlert(message: String) {
		let alert = AlertGenerate.alert(title: "Error", message: message, controller: self, buttons: nil, completion: nil)
		present(alert, animated: true, completion: nil)
	}
	
}

extension UIViewController: StoryboardInstantiable {
	static var storyboardIdentifier: String {
		// Get the name of current class
		let classString = NSStringFromClass(self)
		let components = classString.components(separatedBy: ".")
		assert(components.count > 0, "Failed extract class name from \(classString)")
		return components.last!
	}

	class func instantiateFromStoryboard(storyboard: UIStoryboard) -> Self {
		return instantiateFromStoryboard(storyboard: storyboard, type: self)
	}
}

extension UIViewController {
	private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
		return storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! T
	}
}
