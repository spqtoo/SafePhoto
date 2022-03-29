//
//  LocalAuthManager.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 27.11.2021.
//

import Foundation
import LocalAuthentication

protocol LocalAuthManagerProtocol {

    var isBlocked: Bool { get }
    var delegate: LocalAuthManagerDelegate? { get set }

    func route()
    func sceneWillEnterForeground()
    func sceneWillResignActive()
    func sceneDidEnterBackground()

    func lock()
    func login(with value: [Int]) -> Bool
    func authWithBiometric()
}

protocol LocalAuthManagerDelegate: AnyObject {

    func blurWindow()
    func removeBlur()
    func showContent()
    func showLogin()
}

final class LocalAuthManager {

    weak var delegate: LocalAuthManagerDelegate?
    private var logoutTime: TimeInterval?

    private var shouldBlockAppByTime: Bool {
        if let logoutTime = logoutTime {
            let diff = Date().timeIntervalSince1970 - logoutTime
            return diff > 5
        }
        return false
    }
}

extension LocalAuthManager: LocalAuthManagerProtocol {

    var isBlocked: Bool {
        Shared.get()
    }

    func route() {
        switch isBlocked {
        case true:
            delegate?.showLogin()

        case false:
            delegate?.showContent()
        }
    }

    func sceneWillEnterForeground() {
        lockByTimeIfNeeded()
        if isBlocked {
            delegate?.showLogin()
        }
        delegate?.removeBlur()
    }

    func sceneWillResignActive() {
        delegate?.blurWindow()
    }

    func sceneDidEnterBackground() {
        logoutTime = Date().timeIntervalSince1970
        delegate?.blurWindow()
    }

    func authWithBiometric() {
        guard isBlocked else { return }
        DispatchQueue.main.async { [weak self] in
            let context = LAContext()
            var error: NSError?
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return }
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Needs to unlock app") {
                [weak self] success, authenticationError in
                DispatchQueue.main.async { [weak self] in
                    guard success else { return }
                    self?.unlock()
                }
            }
        }
    }

    func lock() {
        Shared.set(true)
        delegate?.blurWindow()
    }

    func login(with value: [Int]) -> Bool {
        return false
    }

    private func lockByTimeIfNeeded() {
        defer { logoutTime = nil }
        guard shouldBlockAppByTime else { return }
        lock()
    }

    private func unlock() {
        logoutTime = nil
        Shared.set(false)
        delegate?.showContent()
    }
}

private extension LocalAuthManager {

    private struct Shared {
        private static var isLocked = true

        static func set(_ value: Bool) {
#if !DEBUG
            isLocked = value
#else
            isLocked = false
#endif
        }

        static func get() -> Bool {
#if !DEBUG
            return isLocked
#else
            return false
#endif
        }
    }
}
