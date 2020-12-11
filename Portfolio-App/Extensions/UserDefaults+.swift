//
//  UserDefaults+.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 11.12.2020.
//

import UIKit

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {

    @UserDefault(key: "have_active_profile", defaultValue: false)
    static var haveActiveProfile: Bool
}
