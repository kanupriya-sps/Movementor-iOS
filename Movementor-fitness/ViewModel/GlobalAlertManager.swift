//
//  GlobalAlertManager.swift
//  Movementor-fitness
//
//  Created by user on 20/12/24.
//

import SwiftUI

class GlobalAlertManager: ObservableObject {
    static let shared = GlobalAlertManager()
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private init() {}
    
    func triggerAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.alertTitle = title
            self.alertMessage = message
            self.showAlert = true
        }
    }
}
