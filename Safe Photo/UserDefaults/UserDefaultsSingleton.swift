//
//  UserDefaultsSingleton.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 28.11.2021.
//

import UIKit

final class UserDefaultsSingleton {

    static let shared = UserDefaultsSingleton()

    private var defaults = UserDefaults.standard

    private func read<T>(property: String = #function) -> T? {
        defaults.object(forKey: getKey(property)) as? T
    }
    private func write<T>(value: T, to property: String = #function) {
        defaults.setValue(value, forKey: getKey(property))
    }

    private func read<T>(key: String) -> T? {
        defaults.object(forKey: getKey(key)) as? T
    }
    private func write<T>(value: T, key: String) {
        defaults.setValue(value, forKey: getKey(key))
    }

    private func readObject<T: Decodable>(property: String = #function) -> T? {
        guard let value = defaults.value(forKey: getKey(property)) as? Data else { return nil }
        let newValue = try? JSONDecoder().decode(T.self, from: value)
        return newValue
    }
    private func writeObject<T: Encodable>(value: T, to property: String = #function) {
        let newValue = try? JSONEncoder().encode(value)
        defaults.set(newValue, forKey: getKey(property))
    }

    private func getKey(_ val: String) -> String {
        "Settings_\(val)"
    }

    private init() {}
}

extension UserDefaultsSingleton {

    var appLaunch: Int {
        get { read() ?? 0 }
        set { write(value: newValue) }
    }

    var isPasswordEnabled: Bool {
        get { read() ?? false}
        set { write(value: newValue)}
    }

    var isBiometricAuthEnabled: Bool {
        get { read() ?? true}
        set { write(value: newValue)}
    }
}

