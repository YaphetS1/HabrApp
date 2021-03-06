//
// Created by Dmitry Marinin on 2019-02-14.
// Copyright (c) 2019 DM. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - Properties
final class FeedViewModel {

// Input
    let provider = FeedProvider()
    let reloadTrigger: PublishSubject<Void> = PublishSubject()

// Output
    lazy private(set) var hubs: Observable<[HubViewModel]> = self.setupHubs()

// MARK: - Reactive Setup

    fileprivate func setupHubs() -> Observable<[HubViewModel]> {
        return self.reloadTrigger
                .asObservable()
                .observeOn(MainScheduler.instance)
                .flatMapLatest { [unowned self] (_) -> Observable<[HubViewModel]> in
                    return self.provider.fetchHubs()
                            .catchErrorJustReturn([])
                }
                .share(replay: 1)
    }
}