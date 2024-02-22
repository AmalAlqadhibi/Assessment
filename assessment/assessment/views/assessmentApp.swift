//
//  assessmentApp.swift
//  assessment
//
//  Created by Amal Alqadhibi on 18/02/2024.
//

import SwiftUI

@main
struct assessmentApp: App {
    var body: some Scene {
        WindowGroup {
            let viewmodel = LoginViewModel()
            LoginView(viewModel: viewmodel)
        }
    }
}
