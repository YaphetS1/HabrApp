//
//  BaseContainer.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import UIKit
import SnapKit

class BaseContainer: UIViewController {
	
	func showContainedController(_ controller: UIViewController, container: UIView) {
		addChild(controller)
		container.addSubview(controller.view)
		controller.didMove(toParent: self)
		
		controller.view.translatesAutoresizingMaskIntoConstraints = false
		controller.view.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
	
	func hideContainedController(_ controller: UIViewController) {
		controller.willMove(toParent: nil)
		controller.view.removeFromSuperview()
		controller.removeFromParent()
	}
	
	func replaceContainedController(from fromController: UIViewController, to toController: UIViewController, container: UIView, animated: Bool = true) {
		fromController.willMove(toParent: nil)
		
		addChild(toController)
		container.addSubview(toController.view)
		
		toController.view.translatesAutoresizingMaskIntoConstraints = false
		toController.view.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		toController.view.alpha = 0
		
		UIView.animate(withDuration: 0.5, delay: 0.1, options: .transitionCrossDissolve, animations: {
			toController.view.alpha = 1
			fromController.view.alpha = 0
		}, completion: { (finished) in
			fromController.view.removeFromSuperview()
			fromController.removeFromParent()
			toController.didMove(toParent: self)
		})
	}
}
