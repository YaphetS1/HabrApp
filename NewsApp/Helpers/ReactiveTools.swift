//
//  ReactiveTools.swift
//
// Created by Dmitry Marinin on 2019-02-14.
// Copyright © 2019 DM. All rights reserved.
//

import RxSwift

// MARK: - Reactive protocol

protocol ReactiveDisposable {

    var disposeBag: DisposeBag { get }
}

// MARK: - ReusableView protocol

protocol ReusableView: class {

    static var DefaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {

    static var DefaultReuseIdentifier: String {
        print(NSStringFromClass(self))
        return NSStringFromClass(self)
    }
}

// MARK: - NibLoadableView protocol

protocol NibLoadableView: class {

    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {

    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

// MARK: - UITableView extension

extension UITableView {

    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        self.register(T.self, forCellReuseIdentifier: T.DefaultReuseIdentifier)
    }

    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: T.DefaultReuseIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.DefaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.DefaultReuseIdentifier)")
        }
        return cell
    }
}