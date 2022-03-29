//
//  BiometricType.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 28.11.2021.
//

import LocalAuthentication

var biometricType: BiometricType = {
    let authContext = LAContext()
    let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    switch(authContext.biometryType) {
    case .none:
        return .none
    case .touchID:
        return .touch
    case .faceID:
        return .face
    @unknown default:
        return .none
    }
}()

enum BiometricType {
    case none
    case touch
    case face

    var isFaceId: Bool { self == .face }
}
