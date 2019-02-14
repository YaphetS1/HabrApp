//
//  Tools.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import Foundation
import UIKit

extension Date {

    func stringForHubCell() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }

}

extension String {

    func dateFromHabrRss() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss 'GMT'"
        return dateFormatter.date(from: self)
    }

    func removeHtmlTags() -> String {
        return replacingOccurrences(
                of: "<[^>]+>",
                with: "",
                options: .regularExpression,
                range: nil)
    }

    func trim() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard! {

        guard let mainStoryboardName = Bundle.main.infoDictionary?["UIMainStoryboardFile"] as? String else {
            assertionFailure("No UIMainStoryboardFile found in main bundle")
            return nil
        }

        return UIStoryboard(name: mainStoryboardName, bundle: Bundle.main)
    }
}

struct AlertGenerate {
    static func alert(title: String?,
                      message: String?,
                      controller: UIViewController,
                      buttons: [String]?,
                      completion: ((UIAlertAction, UIViewController, Int) -> Void)?) -> UIAlertController {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let buttons = buttons {
            for (index, text) in buttons.enumerated() {
                let action = UIAlertAction(title: text, style: .default) { (action) in
                    completion?(action, controller, index)
                }
                alert.addAction(action)
            }
        }
        else {
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
                completion?(action, controller, 0)
            }
            alert.addAction(action)
        }

        return alert
    }
}