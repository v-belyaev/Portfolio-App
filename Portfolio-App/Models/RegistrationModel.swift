//
//  RegistrationModel.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 12.12.2020.
//

import Foundation

class RegistrationModel {
    
    var state = State.initialState {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("changeView"), object: nil)
        }
    }
    
    func nextState() {
        switch state {
        case .initialState:
            state = .phoneAndMailState
        case .phoneAndMailState:
            state = .finalState
        case .finalState:
            break
        }
    }
    
    func previousState() {
        switch state {
        case .initialState:
            break
        case .phoneAndMailState:
            state = .initialState
        case .finalState:
            state = .phoneAndMailState
        }
    }
    
    enum State {
        case initialState
        case phoneAndMailState
        case finalState
    }
}
