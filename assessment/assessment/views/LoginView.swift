//
//  ContentView.swift
//  assessment
//
//  Created by Amal Alqadhibi on 18/02/2024.
//

import SwiftUI

struct LoginView: View {
    
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var isPresented = false
    
    @FocusState private var textfieldIsFocused: Bool
    @ObservedObject var viewModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Hello,")
            
            TextField("", text: $userName, prompt: Text("User name")
                .foregroundColor(Color(uiColor: .lightGray).opacity(0.5)))
            .focused($textfieldIsFocused)
            .frame(height: 35)
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
            )
            
            SecureField("", text: $password, prompt: Text("Password")
                .foregroundColor(Color(uiColor: .lightGray).opacity(0.5)))
            .focused($textfieldIsFocused)
            .frame(height: 35)
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
            )
            
            
            Button {
                viewModel.saveToKeychain(for: userName, password: password)
                dismiss()
            } label: {
                Spacer()
                Text("login")
                    .foregroundColor(.white)
                    .background(Color(.systemBlue))
                Spacer()
            }
            .fullScreenCover(isPresented: $viewModel.isPresented) {
                let viewModel = HomePageViewModel()
                HomePage(viewModel: viewModel)
            }
            .padding(10)
            .padding()
        }
        .onTapGesture { textfieldIsFocused = false }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
