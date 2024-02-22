//
//  userListPage.swift
//  assessment
//
//  Created by Amal Alqadhibi on 18/02/2024.
//

import SwiftUI

struct UserListPageView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                List() {
                    ForEach($viewModel.users , id: \.self.id) { $user in
                        UserRowView(user: user)
                    }
                }
            }
            .padding()
        }.navigationBarBackButtonHidden(false)
    }
}


