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

    let habrClient = HabrRSSClient()
    let persistenceManager = PersistenceManager.shared
    let reachability = Reachability()

    let disposeBag: DisposeBag = DisposeBag()

    init() {
    }

    func fetchHubs() -> Observable<[HubEntity]> {
        switch reachability?.connection {
        case .none:
            return loadFromCache()
        default:
            return loadFromNetwork()
        }
    }

    private func loadFromCache() -> Observable<[HubEntity]> {
        let hubs = persistenceManager.fetch(HubEntity.self)
        return Observable.just(hubs)
    }

    private func loadFromNetwork() -> Observable<[HubEntity]> {
        return Observable<[HubEntity]>.create { [weak self] (observer) -> Disposable in
            return Disposables.create {
                self?.habrClient.getRSSFeed { [weak self] (data, error) in
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
                        var hubs: [HubEntity] = []

                        for xmlItem in xmlItems {
                            let object = HubEntity(context: context)
                            object.populateFromXML(xmlItem)
                            hubs.append(object)
                        }

                        do {
                            try context.save()
                            print("Saved successfully")
                        } catch {
                            let nserror = error as NSError
                            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                        }
                        observer.onNext(hubs)
                        observer.onCompleted()
                    }
                }
            }
        }

    }
}
