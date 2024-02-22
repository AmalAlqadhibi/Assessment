//
//  webSocket.swift
//  assessment
//
//  Created by Amal Alqadhibi on 18/02/2024.
//

import Foundation
import Combine

class WebSocketManager: NSObject, ObservableObject {
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var urlSession: URLSession?
    
    @Published var connectionStatus: WebSocketConnectionStatus = .disconnected
    @Published var newMessage: String = ""
    
     override init(){
         super.init()
        urlSession = URLSession(configuration: .default , delegate: self, delegateQueue: OperationQueue())
    }
    
    
    
    
    
    func connect(){
        let url = URL(string: "wss://echo.websocket.org/")
        guard let url = url , let urlSession = urlSession else {return}
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        connectionStatus = .connected
        self.listenForMessage()
    }
    
    func disconnect(){
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        connectionStatus = .disconnected
    }
    
    func sendMessage(text: String){
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message, completionHandler: { error in
            
        })
    }
    
    func listenForMessage(){
        webSocketTask?.receive { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .data(let data):
                    print("data \(data.count)")
                case .string(let text):
                    processRespose(text: text)
                @unknown default:
                    print("error")
                }
                
            }
            
            DispatchQueue.main.async {
                self.listenForMessage()
            }
        }
        
    }
    
    func processRespose(text: String){
        self.newMessage = text
    }
    
    
    
}
extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        connectionStatus = .connected
        ping()
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.connectionStatus = .disconnected
    }
    
    
    func ping() {
        webSocketTask?.sendPing{ error in
            if let _ = error {
                self.disconnect()
            } else {
                DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                    self.ping()
                }
            }
        }
        
    }
}
