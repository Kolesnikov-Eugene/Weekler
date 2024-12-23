//
//  WeeklerUIManager.swift
//  Weekler
//
//  Created by Eugene Kolesnikov on 23.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class WeeklerUIManager {
    //    @objc dynamic var selectedColor: UIColor = .red
    //    static let shared = WeeklerUIManager()
    
    static let shared = WeeklerUIManager()
    
    private init() {}
    
    // TODO: - implement rx logic
    var selectedColor: UIColor = .red {
        didSet {
            // Notify all observers about the color change
            NotificationCenter.default.post(name: .colorDidChange, object: nil)
//            NotificationCenter.default.post(name: .colorDidChange, object: newValue)
        }
    }
    
}

// Define a notification name for color change
extension Notification.Name {
    static let colorDidChange = Notification.Name("ColorDidChangeNotification")
}

// multicast

//let subject = PublishSubject<Int>()
//let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).multicast(subject)
//let disposeBag = DisposeBag()
//
//// Subscriber 1
//observable.subscribe(onNext: { value in
//    print("Subscriber 1 received: \(value)")
//}).disposed(by: disposeBag)
//
//// Subscriber 2
//observable.subscribe(onNext: { value in
//    print("Subscriber 2 received: \(value)")
//}).disposed(by: disposeBag)
//
//// Connect the multicast observable
//observable.connect().disposed(by: disposeBag)
