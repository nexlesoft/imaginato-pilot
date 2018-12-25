//
//  HistorySearchViewModel.swift
//  ImaginatoPilot
//
//  Created by Thanh Gieng on 12/24/18.
//  Copyright © 2018 GPThanh. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa



class HistorySearchViewModel {
    let disposeBag = DisposeBag()
    var listSearchHistorys = Variable<NSMutableArray>([])

    init() {
        self.fetchAndUpdateObservableHistorysSearch()
    }
    
    public func fetchAndUpdateObservableHistorysSearch() {
        self.fetchHistorysSearchList().map({$0})?.subscribe(onNext: { [weak self](list) in
            self?.listSearchHistorys.value = list
        }, onError: { (error: Error) in
            print("Error ==> ",error)
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
    }

    public func fetchData() -> NSMutableArray {
        if let data = UserDefaults.standard.object(forKey: keyListHistory) as? Data {
            if let array =  NSKeyedUnarchiver.unarchiveObject(with: data) as? NSMutableArray {
                return array
            }
        }
        return NSMutableArray()
    }
    
    public func fetchHistorysSearchList() -> Observable<NSMutableArray>? {
        return Observable.from(optional: self.fetchData())
    }
    
    public func addHistorySearh(withStr strSearch: String) {
        let listSearch = self.fetchData()
        let index = listSearch.index(of: strSearch)
        if index != NSNotFound {
            listSearch.removeObject(at: index)
        }
        if listSearch.count >= 10 {
            listSearch.removeLastObject()
        }
        listSearch.insert(strSearch.trim(), at: 0)
        self.savaData(listSearch: listSearch)
        self.listSearchHistorys.value = fetchData()
    }
    
    public func savaData(listSearch:NSMutableArray) {
        let data = NSKeyedArchiver.archivedData(withRootObject: listSearch)
        UserDefaults.standard.setValue(data, forKey: keyListHistory)
        UserDefaults.standard.synchronize()
    }
    
    public func removeHistorySearch(withIndex index: Int) {
        let listSearch = self.listSearchHistorys.value
        listSearch.removeObject(at: index)
        self.savaData(listSearch: listSearch)
        self.listSearchHistorys.value = fetchData()
    }
}
