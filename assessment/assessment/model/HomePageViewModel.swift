//
//  HomePageViewModel.swift
//  assessment
//
//  Created by Amal Alqadhibi on 20/02/2024.
//

import Foundation
import Combine

public enum WebSocketConnectionStatus: String {
    case connecting = "connecting"
    case connected = "connected"
    case disconnected = "disconnected"
}

class HomePageViewModel: ObservableObject {
    
    @Published var userName: String = UserDefaults.standard.string(forKey: "account") ?? ""
    @Published var bottonTitle: String = "Connect"
    @Published var newMessage: String = ""
    @Published var connectionStatus: WebSocketConnectionStatus = .disconnected
    @Published var isPresented = false
    
    var webSocketManager: WebSocketManager
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.webSocketManager = WebSocketManager()
        observeWebSocketStates()
        observeNewMessage()
    }
    
    func connectWebSocket(){
        guard connectionStatus == .disconnected else {return}
        webSocketManager.connect()
    }
    
    func disconnectWebSocket(){
        guard connectionStatus == .connected else {return}
        webSocketManager.disconnect()
    }
    
    func sendMessage(_ message: String){
        guard connectionStatus == .connected else {
            return
        }
        webSocketManager.sendMessage(text: message)
    }
    
    func listenForMessage(_ message: String){
        webSocketManager.listenForMessage()
    }
    
    private func observeWebSocketStates() {
        webSocketManager.$connectionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status != self?.connectionStatus {
                    self?.connectionStatus = status
                    if status == .connected {
                        self?.bottonTitle = "Disconnect"
                    } else {
                        self?.bottonTitle = "Connect"
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func observeNewMessage() {
        webSocketManager.$newMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                if message != self?.newMessage {
                    self?.newMessage = message
                    self?.isPresented = true
                }
            }.store(in: &cancellables)
    }
}
