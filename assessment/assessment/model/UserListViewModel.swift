//
//  UserListViewModel.swift
//  assessment
//
//  Created by Amal Alqadhibi on 19/02/2024.
//

import Foundation
import Combine
import CoreData




class UserListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    private var cancellables = Set<AnyCancellable>()
    private let viewContext = CoreDataManager.shared.viewContext
    
    init() {
        fetchUsers()
    }

    
    func fetchUsers() {
        guard let url = URL(string: "https://gorest.co.in/public-api/users") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw appError.HTTPError
                }
                return output.data
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
        
            .map { [weak self] response in
                self?.saveUsersToCoreData(response.data)
                            return response
            }
           
            
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.fetchCompanyData()
                }
            } receiveValue: { response in
                self.users = response.data
            }
            .store(in: &cancellables)
    }
    
    func fetchCompanyData() {
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        
        do {
            self.users = try viewContext.fetch(request).map { User(entity: $0) }
        } catch {
            print("Some error occured while fetching")
        }
    }
    
    private func saveUsersToCoreData(_ users: [User]) {
        for user in users {
            let userEntity = UserEntity(context: viewContext)
            userEntity.id = Int64(user.id)
            userEntity.name = user.name
            userEntity.email = user.email
        }

        CoreDataManager.shared.saveContext()
    }
}

struct UserResponse: Codable {
    let data: [User]
}

