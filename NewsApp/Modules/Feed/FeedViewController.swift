//
//  FeedViewController.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FeedViewController: UIViewController, ReactiveDisposable {

    @IBOutlet weak var tableView: UITableView!

    let disposeBag: DisposeBag = DisposeBag()
    fileprivate let viewModel: FeedViewModel = FeedViewModel()
    fileprivate let refreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupBindings()

        self.viewModel.reloadTrigger.onNext(())
    }

    private func setupBindings() {

       self.viewModel.hubs
                .bind(to: self.tableView.rx.items(
                        cellIdentifier: HubTableViewCell.DefaultReuseIdentifier,
                        cellType: HubTableViewCell.self)) { (row, hubViewModel: HubViewModel, cell: HubTableViewCell) in
                    cell.setup(with: hubViewModel)
                }
                .disposed(by: self.disposeBag)

        // Bind refresh control to data reload
        self.refreshControl.rx
                .controlEvent(.valueChanged)
                .filter({ [weak self] _ in
                    self!.refreshControl.isRefreshing
                })
                .bind(to: self.viewModel.reloadTrigger)
                .disposed(by: self.disposeBag)

        // Bind view model albums to the refresh control
        self.viewModel.hubs
                .subscribe { [weak self] _ in
                    self!.refreshControl.endRefreshing()
                }.disposed(by: self.disposeBag)
    }

    fileprivate func setupTableView() {
        self.tableView.registerReusableCell(HubTableViewCell.self)
        self.tableView.addSubview(self.refreshControl)
    }
}

