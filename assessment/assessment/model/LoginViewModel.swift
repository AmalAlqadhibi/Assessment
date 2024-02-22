//
//  LoginViewModel.swift
//  assessment
//
//  Created by Amal Alqadhibi on 18/02/2024.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var isPresented = false
    
    func saveToKeychain(for account: String ,password: String){
        do {
            UserDefaults.standard.set(account, forKey: "account")//TODO:- add key in constant struct
            try KeychainHelper.savePassword(for: account, password: password)
            isPresented = true
        } catch {
            print("error in keychain \(error)")
        }
    }
    
}
