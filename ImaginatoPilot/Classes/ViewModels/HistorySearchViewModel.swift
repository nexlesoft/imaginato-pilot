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
    var listSearchHistorys = Variable<[HistoryViewModel]>([])
    init() {
        self.fetchAndUpdateObservableHistorysSearch()
    }
    
    public func fetchAndUpdateObservableHistorysSearch() {
        self.fetchHistorysSearchList().map({$0}).subscribe(onNext: { [weak self](list) in
            self?.listSearchHistorys.value = list
        }, onError: { (error: Error) in
            print("Error ==> ",error)
        }, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
    }

    public func fetchData() -> ([HistoryViewModel],NSMutableArray){
        var listSearchViewModel = [HistoryViewModel]()
        var listSearch = NSMutableArray()
        if let data = UserDefaults.standard.object(forKey: keyListHistory) as? Data {
            if let array =  NSKeyedUnarchiver.unarchiveObject(with: data) as? NSMutableArray {
                for item in array {
                    listSearchViewModel.append(HistoryViewModel(str: (item as? String) ?? ""))
                }
                listSearch = array
                return (listSearchViewModel,listSearch)
            }
        }
        return (listSearchViewModel,listSearch)
    }
    
    public func fetchHistorysSearchList() -> Observable<[HistoryViewModel]> {
//        let listSearch = self.fetchData()
        return Observable.from(optional: self.fetchData().0)
    }
    
    public func addHistorySearh(strSearch:String) {
        let listSearch = self.fetchData().1
        let index = listSearch.index(of: strSearch)
        if index != NSNotFound {
            listSearch.removeObject(at: index)
        }
        if listSearch.count >= 10 {
            listSearch.removeLastObject()
        }
        listSearch.insert(strSearch.trim(), at: 0)
        self.savaData(listSearch: listSearch)
        self.listSearchHistorys.value = fetchData().0
    }
    
    public func savaData(listSearch:NSMutableArray) {
        let data = NSKeyedArchiver.archivedData(withRootObject: listSearch)
        UserDefaults.standard.setValue(data, forKey: keyListHistory)
        UserDefaults.standard.synchronize()
    }
    
    public func removeHistorySearch(withIndex index: Int) {
        let listSearch = self.fetchData().1
        listSearch.removeObject(at: index)
        self.savaData(listSearch: listSearch)
        self.listSearchHistorys.value = fetchData().0
    }
}
