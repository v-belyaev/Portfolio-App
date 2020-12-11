//
//  LAContext+.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 12.12.2020.
//

import Foundation
import LocalAuthentication

enum BiometricsAuthResult {
    case success
    case cancelled
    case failed
}

extension LAContext {
    static var canUseBiometrics: Bool {
        let context = LAContext()
        let hasAuthenticationWithBiometrics = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        return context.canEvaluatePolicy(hasAuthenticationWithBiometrics, error: nil)
    }
    
    static var isBiometricsAvailable: Bool {
        var error: NSError?
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            if error?.code == Int(kLAErrorBiometryNotAvailable) {
                return false
            } else {
                return true
            }
        }
    }
    
    static var isPasscodeEnabled: Bool {
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    static func biometricType() -> BiometricType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            assertionFailure("unknown biometry type")
            return .none
        }
    }
    
    enum BiometricType {
        case none
        case touch
        case face
    }
}
