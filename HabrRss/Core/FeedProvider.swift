//
//  FeedProvider.swift
//
//  Created by Dmitry Marinin on 2019-02-14.
//  Copyright © 2019 DM. All rights reserved.
//

import SWXMLHash
import Reachability
import RxSwift

final class FeedProvider: ReactiveDisposable {

    let persistenceManager = PersistenceManager.shared
    let reachability = Reachability()

    let disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    func fetchHubs() -> Observable<[HubViewModel]> {
        switch reachability?.connection {
        case .none:
            return loadFromCache()
        default:
            return loadFromNetwork()
        }
    }

    private func loadFromCache() -> Observable<[HubViewModel]> {
        let hubs = persistenceManager.fetch(HubEntity.self)
        return Observable.just(hubs.map { HubViewModel(entity: $0) })
    }

    private func loadFromNetwork() -> Observable<[HubViewModel]> {
        return Observable<[HubViewModel]>.create { [weak self] (observer) -> Disposable in
            let url = URL(string: Constants.baseURL)!

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let strongSelf = self else {
                    return
                }

                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let data = data else {
                    return
                }

                let xml = SWXMLHash.parse(data)
                let xmlItems = xml["rss"]["channel"]["item"].all

                let context = strongSelf.persistenceManager.newBackgroundContext()
                context.performAndWait {
                    var hubsViewModel: [HubViewModel] = []

                    for xmlItem in xmlItems {
                        let object = HubEntity(context: context)
                        object.populateFromXML(xmlItem)

                        hubsViewModel.append(HubViewModel(entity: object))
                    }

                    do {
                        try context.save()
                        print("Saved successfully")
                        observer.onNext(hubsViewModel)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                }
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
