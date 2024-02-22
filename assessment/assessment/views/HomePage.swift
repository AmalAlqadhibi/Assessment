//
//  HomePage.swift
//  assessment
//
//  Created by Amal Alqadhibi on 18/02/2024.

import SwiftUI

struct HomePage: View {
    @State private var message: String = ""
    @State private var isPresented = false
    
    
    @FocusState private var textfieldIsFocused: Bool
    @ObservedObject var viewModel: HomePageViewModel
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Text("Hello,\(viewModel.userName)")
                    Spacer()
                    Button {
                        isPresented = true
                    } label: {
                        Spacer()
                        Text("users List")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .background(Color(.systemBlue))
                        Spacer()
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        let viewModel = UserListViewModel()
                        UserListPageView(viewModel: viewModel)
                    }
                    .cornerRadius(15)
                    .padding(10)
                    .padding()
                }
                .padding()
                Spacer()
                
                Text("web socket \(viewModel.connectionStatus.rawValue)")
                Button {
                    if viewModel.connectionStatus == .disconnected {
                        viewModel.connectWebSocket()
                    } else {
                        viewModel.disconnectWebSocket()
                    }
                } label: {
                    Spacer()
                    
                    Text(viewModel.bottonTitle)
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        
                    
                    Spacer()
                    
                }
                .background(Color(.systemBlue))
                .cornerRadius(15)
                .padding(10)
                .padding()
                Spacer()
                HStack {
                    TextField("", text: $message, prompt: Text("User name")
                        .foregroundColor(Color(uiColor: .lightGray).opacity(0.5)))
                    .focused($textfieldIsFocused)
                    .frame(height: 35)
                    .cornerRadius(5)
                    .padding(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color(uiColor: .secondarySystemBackground))
                    )
                    
                    Button(action: {
                        viewModel.sendMessage(message)
                        message = ""
                        
                    }) {
                        Image(systemName: "paperplane")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .alert(viewModel.newMessage, isPresented: $viewModel.isPresented){
                Button("Dismiss", role: .cancel) {}
            }
        }.onTapGesture { textfieldIsFocused = false }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage(viewModel: HomePageViewModel())
    }
}
